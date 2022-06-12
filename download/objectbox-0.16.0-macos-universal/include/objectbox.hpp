/*
 * Copyright 2018-2022 ObjectBox Ltd. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#pragma once

#include <algorithm>
#include <atomic>
#include <cstring>
#include <memory>
#include <mutex>
#include <string>
#include <vector>

#include "objectbox.h"

#ifndef OBX_DISABLE_FLATBUFFERS  // FlatBuffers is required to put data; you can disable it until have the include file.
#include "flatbuffers/flatbuffers.h"
#endif

#ifdef __cpp_lib_optional
#include <optional>
#endif

static_assert(OBX_VERSION_MAJOR == 0 && OBX_VERSION_MINOR == 16 && OBX_VERSION_PATCH == 0,
              "Versions of objectbox.h and objectbox.hpp files do not match, please update");

static_assert(sizeof(obx_id) == sizeof(OBX_id_array::ids[0]),
              "Can't directly link OBX_id_array.ids to std::vector<obx_id>::data()");

namespace obx {

/**
 * @defgroup cpp ObjectBox C++ API
 * @{
 */

/// Database related exception, containing a error code to differentiate between various errors.
/// Note: what() typically contains a specific text about the error condition (sometimes helpful to resolve the issue).
class DbException : public std::runtime_error {
    const int code_;

public:
    explicit DbException(const std::string& text, int code = 0) : runtime_error(text), code_(code) {}
    explicit DbException(const char* text, int code = 0) : runtime_error(text), code_(code) {}

    /// The error code as defined objectbox.h via the OBX_ERROR_* constants
    int code() const { return code_; }
};

/// Transactions can be started in read (only) or write mode.
enum class TxMode { READ, WRITE };

namespace {
#define OBJECTBOX_VERIFY_ARGUMENT(c) \
    ((c) ? (void) (0) : throw std::invalid_argument(std::string("Argument validation failed: " #c)))

#define OBJECTBOX_VERIFY_STATE(c) \
    ((c) ? (void) (0) : throw std::runtime_error(std::string("State condition failed: " #c)))

/// @throws DbException using the given error (defaults to obx_last_error_code())
[[noreturn]] void throwLastError(obx_err err = obx_last_error_code()) {
    if (err == OBX_SUCCESS) {  // Zero, there's no error actually
        throw DbException("No error occurred (operation was successful)", err);
    } else {
        obx_err lastErr = obx_last_error_code();
        if (err == lastErr) {
            assert(lastErr != 0);  // checked indirectly against err before
            throw DbException(obx_last_error_message(), err);
        } else {  // Do not use obx_last_error_message() as primary msg because it originated from another code
            std::string msg("Error code " + std::to_string(err));
            if (lastErr != 0) {
                msg.append(" (last: ").append(std::to_string(lastErr));
                msg.append(", last msg: ").append(obx_last_error_message()).append(")");
            }
            throw DbException(msg, err);
        }
    }
}

void checkErrOrThrow(obx_err err) {
    if (err != OBX_SUCCESS) throwLastError();
}

bool checkSuccessOrThrow(obx_err err) {
    if (err == OBX_NO_SUCCESS) return false;
    if (err == OBX_SUCCESS) return true;
    throwLastError(err);
}

template <typename T>
T* checkPtrOrThrow(T* ptr, const std::string& context) {
    if (!ptr) throw DbException(context + ": " + obx_last_error_message(), obx_last_error_code());
    return ptr;
}

template <typename EntityT>
constexpr obx_schema_id entityId() {
    return EntityT::_OBX_MetaInfo::entityId();
}
}  // namespace

template <class T>
class Box;

template <class T>
class AsyncBox;

class Transaction;

class Sync;
class SyncClient;
class SyncServer;

class Closable {
public:
    virtual ~Closable() = default;
    virtual bool isClosed() = 0;
    virtual void close() = 0;
};

/// Options provide a way to configure Store when opening it.
/// Options functions can be chained, e.g. options.directory("mypath/objectbox").maxDbSizeInKb(2048);
/// Note: Options objects can be used only once to create a store as they are "consumed" during Store creation.
///       Thus, you need to create a new Option object for each Store that is created.
class Options {
    friend class Store;
    friend class SyncServer;

    mutable OBX_store_options* opt = nullptr;

    OBX_store_options* release() {
        OBX_store_options* result = opt;
        opt = nullptr;
        return result;
    }

public:
    Options() {
        opt = obx_opt();
        checkPtrOrThrow(opt, "Could not create store options");
    }

    /// @deprecated is this used by generator?
    Options(OBX_model* model) : Options() { this->model(model); }

    ~Options() { obx_opt_free(opt); }

    /// Set the model on the options. The default is no model.
    /// NOTE: the model is always freed by this function, including when an error occurs.
    Options& model(OBX_model* model) {
        checkErrOrThrow(obx_opt_model(opt, model));
        return *this;
    }

    /// Set the store directory on the options. The default is "objectbox".
    Options& directory(const char* dir) {
        checkErrOrThrow(obx_opt_directory(opt, dir));
        return *this;
    }

    /// Set the store directory on the options. The default is "objectbox".
    Options& directory(const std::string& dir) { return directory(dir.c_str()); }

    /// Set the maximum db size on the options. The default is 1Gb.
    Options& maxDbSizeInKb(size_t sizeInKb) {
        obx_opt_max_db_size_in_kb(opt, sizeInKb);
        return *this;
    }

    /// Set the file mode on the options. The default is 0644 (unix-style)
    Options& fileMode(unsigned int fileMode) {
        obx_opt_file_mode(opt, fileMode);
        return *this;
    }

    /// Set the maximum number of readers (related to read transactions.
    /// "Readers" are an finite resource for which we need to define a maximum number upfront.
    /// The default value is enough for most apps and usually you can ignore it completely.
    /// However, if you get the OBX_ERROR_MAX_READERS_EXCEEDED error, you should verify your threading.
    /// For each thread, ObjectBox uses multiple readers.
    /// Their number (per thread) depends on number of types, relations, and usage patterns.
    /// Thus, if you are working with many threads (e.g. in a server-like scenario), it can make sense to increase
    /// the maximum number of readers.
    ///
    /// \note The internal default is currently 126. So when hitting this limit, try values around 200-500.
    ///
    /// \attention Each thread that performed a read transaction and is still alive holds on to a reader slot.
    ///       These slots only get vacated when the thread ends. Thus be mindful with the number of active threads.
    ///       Alternatively, you can opt to try the experimental noReaderThreadLocals option flag.
    Options& maxReaders(unsigned int maxReaders) {
        obx_opt_max_readers(opt, maxReaders);
        return *this;
    }

    /// Disables the usage of thread locals for "readers" related to read transactions.
    /// This can make sense if you are using a lot of threads that are kept alive.
    /// \note This is still experimental, as it comes with subtle behavior changes at a low level and may affect
    ///       corner cases with e.g. transactions, which may not be fully tested at the moment.
    Options& noReaderThreadLocals(bool flag) {
        obx_opt_no_reader_thread_locals(opt, flag);
        return *this;
    }

    /// Set the model on the options copying the given bytes. The default is no model.
    Options& modelBytes(const void* bytes, size_t size) {
        checkErrOrThrow(obx_opt_model_bytes(opt, bytes, size));
        return *this;
    }

    /// Like modelBytes() BUT WITHOUT copying the given bytes.
    /// Thus, you must keep the bytes available until after the store is created.
    Options& modelBytesDirect(const void* bytes, size_t size) {
        checkErrOrThrow(obx_opt_model_bytes_direct(opt, bytes, size));
        return *this;
    }

    /// When the DB is opened initially, ObjectBox can do a consistency check on the given amount of pages.
    /// Reliable file systems already guarantee consistency, so this is primarily meant to deal with unreliable
    /// OSes, file systems, or hardware. Thus, usually a low number (e.g. 1-20) is sufficient and does not impact
    /// startup performance significantly. To completely disable this you can pass 0, but we recommend a setting of
    /// at least 1.
    /// Note: ObjectBox builds upon ACID storage, which guarantees consistency given that the file system is working
    /// correctly (in particular fsync).
    /// @param page_limit limits the number of checked pages (currently defaults to 0, but will be increased in the
    /// future)
    /// @param leaf_level enable for visiting leaf pages (defaults to false)
    Options& validateOnOpen(size_t pageLimit, bool leafLevel) {
        obx_opt_validate_on_open(opt, pageLimit, leafLevel);
        return *this;
    }

    /// Don't touch unless you know exactly what you are doing:
    /// Advanced setting typically meant for language bindings (not end users). See OBXPutPaddingMode description.
    Options& putPaddingMode(OBXPutPaddingMode mode) {
        obx_opt_put_padding_mode(opt, mode);
        return *this;
    }

    /// Advanced setting meant only for special scenarios: setting to false causes opening the database in a
    /// limited, schema-less mode. If you don't know what this means exactly: ignore this flag. Defaults to true.
    Options& readSchema(bool value) {
        obx_opt_read_schema(opt, value);
        return *this;
    }

    /// Advanced setting recommended to be used together with read-only mode to ensure no data is lost.
    /// Ignores the latest data snapshot (committed transaction state) and uses the previous snapshot instead.
    /// When used with care (e.g. backup the DB files first), this option may also recover data removed by the
    /// latest transaction. Defaults to false.
    Options& usePreviousCommit(bool value) {
        obx_opt_use_previous_commit(opt, value);
        return *this;
    }

    /// Open store in read-only mode: no schema update, no write transactions. Defaults to false.
    Options& readOnly(bool value) {
        obx_opt_read_only(opt, value);
        return *this;
    }

    /// Configure debug logging. Defaults to NONE
    Options& debugFlags(OBXDebugFlags flags) {
        obx_opt_debug_flags(opt, flags);
        return *this;
    }

    /// Maximum of async elements in the queue before new elements will be rejected.
    /// Hitting this limit usually hints that async processing cannot keep up;
    /// data is produced at a faster rate than it can be persisted in the background.
    /// In that case, increasing this value is not the only alternative; other values might also optimize
    /// throughput. For example, increasing maxInTxDurationMicros may help too.
    Options& asyncMaxQueueLength(size_t value) {
        obx_opt_async_max_queue_length(opt, value);
        return *this;
    }

    /// Producers (AsyncTx submitter) is throttled when the queue size hits this
    Options& asyncThrottleAtQueueLength(size_t value) {
        obx_opt_async_throttle_at_queue_length(opt, value);
        return *this;
    }

    /// Sleeping time for throttled producers on each submission
    Options& asyncThrottleMicros(uint32_t value) {
        obx_opt_async_throttle_micros(opt, value);
        return *this;
    }

    /// Maximum duration spent in a transaction before AsyncQ enforces a commit.
    /// This becomes relevant if the queue is constantly populated at a high rate.
    Options& asyncMaxInTxDuration(uint32_t micros) {
        obx_opt_async_max_in_tx_duration(opt, micros);
        return *this;
    }

    /// Maximum operations performed in a transaction before AsyncQ enforces a commit.
    /// This becomes relevant if the queue is constantly populated at a high rate.
    Options& asyncMaxInTxOperations(uint32_t value) {
        obx_opt_async_max_in_tx_operations(opt, value);
        return *this;
    }

    /// Before the AsyncQ is triggered by a new element in queue to starts a new run, it delays actually starting
    /// the transaction by this value. This gives a newly starting producer some time to produce more than one a
    /// single operation before AsyncQ starts. Note: this value should typically be low to keep latency low and
    /// prevent accumulating too much operations.
    Options& asyncPreTxnDelay(uint32_t delayMicros) {
        obx_opt_async_pre_txn_delay(opt, delayMicros);
        return *this;
    }

    /// Before the AsyncQ is triggered by a new element in queue to starts a new run, it delays actually starting
    /// the transaction by this value. This gives a newly starting producer some time to produce more than one a
    /// single operation before AsyncQ starts. Note: this value should typically be low to keep latency low and
    /// prevent accumulating too much operations.
    Options& asyncPreTxnDelay(uint32_t delayMicros, uint32_t delay2Micros, size_t minQueueLengthForDelay2) {
        obx_opt_async_pre_txn_delay4(opt, delayMicros, delay2Micros, minQueueLengthForDelay2);
        return *this;
    }

    /// Similar to preTxDelay but after a transaction was committed.
    /// One of the purposes is to give other transactions some time to execute.
    /// In combination with preTxDelay this can prolong non-TX batching time if only a few operations are around.
    Options& asyncPostTxnDelay(uint32_t delayMicros) {
        obx_opt_async_post_txn_delay(opt, delayMicros);
        return *this;
    }

    /// Similar to preTxDelay but after a transaction was committed.
    /// One of the purposes is to give other transactions some time to execute.
    /// In combination with preTxDelay this can prolong non-TX batching time if only a few operations are around.
    /// @param subtractProcessingTime If set, the delayMicros is interpreted from the start of TX processing.
    ///        In other words, the actual delay is delayMicros minus the TX processing time including the commit.
    ///        This can make timings more accurate (e.g. when fixed batching interval are given).

    Options& asyncPostTxnDelay(uint32_t delayMicros, uint32_t delay2Micros, size_t minQueueLengthForDelay2,
                               bool subtractProcessingTime = false) {
        obx_opt_async_post_txn_delay5(opt, delayMicros, delay2Micros, minQueueLengthForDelay2, subtractProcessingTime);
        return *this;
    }

    /// Numbers of operations below this value are considered "minor refills"
    Options& asyncMinorRefillThreshold(size_t queueLength) {
        obx_opt_async_minor_refill_threshold(opt, queueLength);
        return *this;
    }

    /// If non-zero, this allows "minor refills" with small batches that came in (off by default).
    Options& asyncMinorRefillMaxCount(uint32_t value) {
        obx_opt_async_minor_refill_max_count(opt, value);
        return *this;
    }

    /// Default value: 10000, set to 0 to deactivate pooling
    Options& asyncMaxTxPoolSize(size_t value) {
        obx_opt_async_max_tx_pool_size(opt, value);
        return *this;
    }

    /// Total cache size; default: ~ 0.5 MB
    Options& asyncObjectBytesMaxCacheSize(uint64_t value) {
        obx_opt_async_object_bytes_max_cache_size(opt, value);
        return *this;
    }

    /// Maximal size for an object to be cached (only cache smaller ones)
    Options& asyncObjectBytesMaxSizeToCache(uint64_t value) {
        obx_opt_async_object_bytes_max_size_to_cache(opt, value);
        return *this;
    }
};

class Store {
    OBX_store* cStore_;
    bool owned_ = true;  ///< whether the store pointer is owned (true except for SyncServer::store())
    std::shared_ptr<Closable> syncClient_;
    std::mutex syncClientMutex_;

    friend Sync;
    friend SyncClient;
    friend SyncServer;

    explicit Store(OBX_store* ptr, bool owned) : cStore_(ptr), owned_(owned) {
        OBJECTBOX_VERIFY_ARGUMENT(cStore_ != nullptr);
    }

public:
    explicit Store(OBX_model* model) : Store(Options().model(model)) {}

    explicit Store(Options& options)
        : Store(checkPtrOrThrow(obx_store_open(options.release()), "Can't open store"), true) {}

    explicit Store(Options&& options) : Store((Options&) options) {}

    /// Wraps an existing C-API store pointer, taking ownership (don't close it manually anymore)
    explicit Store(OBX_store* cStore) : Store(cStore, true) {}

    /// Can't be copied, single owner of C resources is required (to avoid double-free during destruction)
    Store(const Store&) = delete;

    Store(Store&& source) noexcept : cStore_(source.cStore_) { source.cStore_ = nullptr; }

    virtual ~Store();

    OBX_store* cPtr() const { return cStore_; }

    template <class EntityBinding>
    Box<EntityBinding> box() {
        return Box<EntityBinding>(*this);
    }

    /// Starts a transaction using the given mode.
    Transaction tx(TxMode mode);

    /// Starts a read(-only) transaction.
    Transaction txRead();

    /// Starts a (read &) write transaction.
    Transaction txWrite();

    /// @return an existing SyncClient associated with the store (if available; see Sync::client() to create one)
    /// @note: implemented in objectbox-sync.hpp
    std::shared_ptr<SyncClient> syncClient();

    /// Enable (or disable) debug logging. This requires a version of the library with OBXFeature_DebugLog.
    static void debugLog(bool enabled) { checkErrOrThrow(obx_debug_log(enabled)); }

    static void removeDbFiles(const std::string& directory) { checkErrOrThrow(obx_remove_db_files(directory.c_str())); }
};

/// Provides RAII wrapper for an active database transaction on the current thread (do not use across threads). A
/// Transaction object is considered a "top level transaction" if it is the first one on the call stack in the thread.
/// If the thread already has an ongoing Transaction, additional Transaction instances are considered "inner
/// transactions".
///
/// The top level transaction defines the actual transaction scope on the DB level. Internally, the top level
/// Transaction object manages (creates and destroys) a Transaction object. Inner transactions use the Transaction
/// object of the top level Transaction.
///
/// For write transactions, the top level call to success() actually commits the underlying Transaction. If inner
/// transactions are spawned, all of them must call success() in order for the top level transaction to be successful
/// and actually commit.
class Transaction {
    TxMode mode_;
    OBX_txn* cTxn_;

public:
    explicit Transaction(Store& store, TxMode mode)
        : mode_(mode), cTxn_(mode == TxMode::WRITE ? obx_txn_write(store.cPtr()) : obx_txn_read(store.cPtr())) {
        checkPtrOrThrow(cTxn_, "can't start transaction");
    }

    /// Never throws
    virtual ~Transaction() { closeNoThrow(); };

    /// Delete because the default copy constructor can break things (i.e. a Transaction can not be copied).
    Transaction(const Transaction&) = delete;

    /// Move constructor, used by Store::tx()
    Transaction(Transaction&& source) noexcept : mode_(source.mode_), cTxn_(source.cTxn_) { source.cTxn_ = nullptr; }

    /// A Transaction is active if it was not ended via success(), close() or moving.
    bool isActive() { return cTxn_ != nullptr; }

    /// The transaction pointer of the ObjectBox C API.
    /// @throws if this Transaction was already closed or moved
    OBX_txn* cPtr() const {
        OBJECTBOX_VERIFY_STATE(cTxn_);
        return cTxn_;
    }

    /// "Finishes" this write transaction successfully; performs a commit if this is the top level transaction and all
    /// inner transactions (if any) were also successful. This object will also be "closed".
    /// @throws Exception if this is not a write TX or it was closed before (e.g. via success()).
    void success() {
        OBX_txn* txn = cTxn_;
        OBJECTBOX_VERIFY_STATE(txn);
        cTxn_ = nullptr;
        checkErrOrThrow(obx_txn_success(txn));
    }

    /// Explicit close to free up resources (non-throwing version).
    /// It's OK to call this method multiple times; additional calls will have no effect.
    obx_err closeNoThrow() {
        OBX_txn* txnToClose = cTxn_;
        cTxn_ = nullptr;
        return obx_txn_close(txnToClose);
    }

    /// Explicit close to free up resources; unlike closeNoThrow() (which is also called by the destructor), this
    /// version throw in the unlikely case of failing.
    /// It's OK to call this method multiple times; additional calls will have no effect.
    void close() { checkErrOrThrow(closeNoThrow()); }
};

inline Transaction Store::tx(TxMode mode) { return Transaction(*this, mode); }
inline Transaction Store::txRead() { return tx(TxMode::READ); }
inline Transaction Store::txWrite() { return tx(TxMode::WRITE); }

namespace {  // internal
/// Internal cursor wrapper for convenience and RAII.
class CursorTx {
    Transaction tx_;
    OBX_cursor* cCursor_;

public:
    explicit CursorTx(TxMode mode, Store& store, obx_schema_id entityId)
        : tx_(store, mode), cCursor_(obx_cursor(tx_.cPtr(), entityId)) {
        checkPtrOrThrow(cCursor_, "can't open a cursor");
    }

    /// Can't be copied, single owner of C resources is required (to avoid double-free during destruction)
    CursorTx(const CursorTx&) = delete;

    CursorTx(CursorTx&& source) noexcept : tx_(std::move(source.tx_)), cCursor_(source.cCursor_) {
        source.cCursor_ = nullptr;
    }

    virtual ~CursorTx() { obx_cursor_close(cCursor_); }

    void commitAndClose() {
        OBJECTBOX_VERIFY_STATE(cCursor_ != nullptr);
        obx_cursor_close(cCursor_);
        cCursor_ = nullptr;
        tx_.success();
    }

    OBX_cursor* cPtr() const { return cCursor_; }
};

/// Collects all visited data
template <typename EntityT>
struct CollectingVisitor {
    std::vector<std::unique_ptr<EntityT>> items;

    static bool visit(void* ptr, const void* data, size_t size) {
        auto self = reinterpret_cast<CollectingVisitor<EntityT>*>(ptr);
        self->items.emplace_back(new EntityT());
        EntityT::_OBX_MetaInfo::fromFlatBuffer(data, size, *(self->items.back()));
        return true;
    }
};

/// Produces an OBX_id_array with internal data referencing the given ids vector. You must
/// ensure the given vector outlives the returned OBX_id_array. Additionally, you must NOT call
/// obx_id_array_free(), because the result is not allocated by C, thus it must not free it.
OBX_id_array cIdArrayRef(const std::vector<obx_id>& ids) {
    return {ids.empty() ? nullptr : const_cast<obx_id*>(ids.data()), ids.size()};
}

/// Consumes an OBX_id_array, producing a vector of IDs and freeing the array afterwards.
/// Must be called right after the C-API call producing cIds in order to check and throw on error correctly.
/// Example: idVectorOrThrow(obx_query_find_ids(cQuery_, offset_, limit_))
/// Note: even if this function throws the given OBX_id_array is freed.
std::vector<obx_id> idVectorOrThrow(OBX_id_array* cIds) {
    if (!cIds) throwLastError();

    try {
        std::vector<obx_id> result;
        if (cIds->count > 0) {
            result.resize(cIds->count);
            OBJECTBOX_VERIFY_STATE(result.size() == cIds->count);
            memcpy(result.data(), cIds->ids, result.size() * sizeof(result[0]));
        }
        obx_id_array_free(cIds);
        return result;
    } catch (...) {
        obx_id_array_free(cIds);
        throw;
    }
}

class QueryCondition;
class QCGroup;

class QueryCondition {
public:
    // We're using pointers so have a virtual destructor to ensure proper destruction of the derived classes.
    virtual ~QueryCondition() = default;

    virtual QCGroup and_(const QueryCondition& other);

    QCGroup operator&&(const QueryCondition& rhs);

    virtual QCGroup or_(const QueryCondition& other);

    QCGroup operator||(const QueryCondition& rhs);

protected:
    virtual obx_qb_cond applyTo(OBX_query_builder* cqb, bool isRoot) const = 0;

    /// Allows Box<EntityT> call the private applyTo() when creating a query.
    /// Partial specialization template friendship is not possible: `template <class T> friend class Box`.
    /// Therefore, we create an internal function that does the job for us.
    /// Note: this is actually not a method but an inline function and only seems visible in the current file.
    friend obx_qb_cond internalApplyCondition(const QueryCondition& condition, OBX_query_builder* cqb, bool isRoot) {
        return condition.applyTo(cqb, isRoot);
    }

    /// Returns a copy (of the concrete class) as unique pointer. Used when grouping conditions together (AND|OR).
    virtual std::unique_ptr<QueryCondition> copyAsPtr() const = 0;

    /// Inlined friend function to call the protected copyAsPtr()
    friend std::unique_ptr<QueryCondition> internalCopyAsPtr(const QueryCondition& condition) {
        return condition.copyAsPtr();
    }

    template <class Derived>
    static std::unique_ptr<QueryCondition> copyAsPtr(const Derived& object) {
        return std::unique_ptr<QueryCondition>(new Derived(object));
    }
};

class QCGroup : public QueryCondition {
    bool isOr_;  // whether it's AND or OR group

    // Must be a vector of pointers because QueryCondition is abstract - we can't have a vector of abstract objects.
    // Must be shared_ptr for our own copyAsPtr() to work, in other words vector of unique pointers can't be copied.
    std::vector<std::shared_ptr<QueryCondition>> conditions_;

public:
    QCGroup(bool isOr, std::unique_ptr<QueryCondition>&& a, std::unique_ptr<QueryCondition>&& b)
        : isOr_(isOr), conditions_({std::move(a), std::move(b)}) {}

    // override to combine multiple chained AND conditions into a same group
    QCGroup and_(const QueryCondition& other) override {
        // if this group is an OR group and we're adding an AND - create a new group
        if (isOr_) return QueryCondition::and_(other);

        // otherwise, extend this one by making a copy and including the new condition in it
        return copyThisAndPush(other);
    }

    // we don't have to create copies of the QCGroup when the left-hand-side can be "consumed and moved" (rvalue ref)
    // Note: this is a "global" function, but declared here as a friend so it can access lhs.conditions
    friend inline QCGroup operator&&(QCGroup&& lhs, const QueryCondition& rhs) {
        if (lhs.isOr_) return lhs.and_(rhs);
        lhs.conditions_.push_back(internalCopyAsPtr(rhs));
        return std::move(lhs);
    }

    // override to combine multiple chained OR conditions into a same group
    QCGroup or_(const QueryCondition& other) override {
        // if this group is an AND group and we're adding an OR - create a new group
        if (!isOr_) return QueryCondition::or_(other);

        // otherwise, extend this one by making a copy and including the new condition in it
        return copyThisAndPush(other);
    }

    // we don't have to create copies of the QCGroup when the left-hand-side can be "consumed and moved" (rvalue ref)
    // Note: this is a "global" function, but declared here as a friend so it can access lhs.conditions
    friend inline QCGroup operator||(QCGroup&& lhs, const QueryCondition& rhs) {
        if (!lhs.isOr_) return lhs.or_(rhs);
        lhs.conditions_.push_back(internalCopyAsPtr(rhs));
        return std::move(lhs);
    }

protected:
    std::unique_ptr<QueryCondition> copyAsPtr() const override {
        return std::unique_ptr<QueryCondition>(new QCGroup(*this));
    };

    QCGroup copyThisAndPush(const QueryCondition& other) {
        QCGroup copy(*this);
        copy.conditions_.push_back(internalCopyAsPtr(other));
        return copy;
    }

    obx_qb_cond applyTo(OBX_query_builder* cqb, bool isRoot) const override {
        if (conditions_.size() == 1) return internalApplyCondition(*conditions_[0], cqb, isRoot);
        OBJECTBOX_VERIFY_STATE(conditions_.size() > 0);

        std::vector<obx_qb_cond> cond_ids;
        cond_ids.reserve(conditions_.size());
        for (const std::shared_ptr<QueryCondition>& cond : conditions_) {
            cond_ids.emplace_back(internalApplyCondition(*cond, cqb, false));
        }
        if (isRoot && !isOr_) {
            // root All (AND) is implicit so no need to actually combine the conditions explicitly
            return 0;
        }

        if (isOr_) return obx_qb_any(cqb, cond_ids.data(), cond_ids.size());
        return obx_qb_all(cqb, cond_ids.data(), cond_ids.size());
    }
};

QCGroup obx::QueryCondition::and_(const QueryCondition& other) {
    return {false, copyAsPtr(), internalCopyAsPtr(other)};
}
inline QCGroup obx::QueryCondition::operator&&(const QueryCondition& rhs) { return and_(rhs); }

QCGroup obx::QueryCondition::or_(const QueryCondition& other) { return {true, copyAsPtr(), internalCopyAsPtr(other)}; }
inline QCGroup obx::QueryCondition::operator||(const QueryCondition& rhs) { return or_(rhs); }

enum class QueryOp {
    Equal,
    NotEqual,
    Less,
    LessOrEq,
    Greater,
    GreaterOrEq,
    Contains,
    StartsWith,
    EndsWith,
    Between,
    In,
    NotIn,
    Null,
    NotNull
};

// Internal base class for all the condition containers. Each container starts with `QC` and ends with the type of the
// contents. That's not necessarily the same as the property type the condition is used with, e.g. for Bool::equals()
// using QCInt64, StringVector::contains query using QCString, etc.
class QC : public QueryCondition {
protected:
    obx_schema_id propId_;
    QueryOp op_;

public:
    QC(obx_schema_id propId, QueryOp op) : propId_(propId), op_(op) {}
    virtual ~QC() = default;

protected:
    std::unique_ptr<QueryCondition> copyAsPtr() const override {
        return std::unique_ptr<QueryCondition>(new QC(*this));
    };

    /// Indicates a programming error when in ObjectBox C++ binding - chosen QC struct doesn't support the desired
    /// condition. Consider changing QueryOp to a template variable - it would enable us to use static_assert() instead
    /// of the current runtime check. Additionally, it might produce better (smaller/faster) code because the compiler
    /// could optimize out all the unused switch statements and variables (`value2`).
    [[noreturn]] void throwInvalidOperation() const {
        throw std::logic_error(std::string("Invalid condition - operation not supported: ") + std::to_string(int(op_)));
    }

    obx_qb_cond applyTo(OBX_query_builder* cqb, bool) const override {
        if (op_ == QueryOp::Null) {
            return obx_qb_null(cqb, propId_);
        } else if (op_ == QueryOp::NotNull) {
            return obx_qb_not_null(cqb, propId_);
        }
        throwInvalidOperation();
    }
};

class QCInt64 : public QC {
    int64_t value1_;
    int64_t value2_;

public:
    QCInt64(obx_schema_id propId, QueryOp op, int64_t value1, int64_t value2 = 0)
        : QC(propId, op), value1_(value1), value2_(value2) {}

protected:
    std::unique_ptr<QueryCondition> copyAsPtr() const override { return QueryCondition::copyAsPtr(*this); };

    obx_qb_cond applyTo(OBX_query_builder* cqb, bool) const override {
        if (op_ == QueryOp::Equal) {
            return obx_qb_equals_int(cqb, propId_, value1_);
        } else if (op_ == QueryOp::NotEqual) {
            return obx_qb_not_equals_int(cqb, propId_, value1_);
        } else if (op_ == QueryOp::Less) {
            return obx_qb_less_than_int(cqb, propId_, value1_);
        } else if (op_ == QueryOp::LessOrEq) {
            return obx_qb_less_or_equal_int(cqb, propId_, value1_);
        } else if (op_ == QueryOp::Greater) {
            return obx_qb_greater_than_int(cqb, propId_, value1_);
        } else if (op_ == QueryOp::GreaterOrEq) {
            return obx_qb_greater_or_equal_int(cqb, propId_, value1_);
        } else if (op_ == QueryOp::Between) {
            return obx_qb_between_2ints(cqb, propId_, value1_, value2_);
        }
        throwInvalidOperation();
    }
};

class QCDouble : public QC {
    double value1_;
    double value2_;

public:
    QCDouble(obx_schema_id propId, QueryOp op, double value1, double value2 = 0)
        : QC(propId, op), value1_(value1), value2_(value2) {}

protected:
    std::unique_ptr<QueryCondition> copyAsPtr() const override { return QueryCondition::copyAsPtr(*this); };

    obx_qb_cond applyTo(OBX_query_builder* cqb, bool) const override {
        if (op_ == QueryOp::Less) {
            return obx_qb_less_than_double(cqb, propId_, value1_);
        } else if (op_ == QueryOp::LessOrEq) {
            return obx_qb_less_or_equal_double(cqb, propId_, value1_);
        } else if (op_ == QueryOp::Greater) {
            return obx_qb_greater_than_double(cqb, propId_, value1_);
        } else if (op_ == QueryOp::GreaterOrEq) {
            return obx_qb_greater_or_equal_double(cqb, propId_, value1_);
        } else if (op_ == QueryOp::Between) {
            return obx_qb_between_2doubles(cqb, propId_, value1_, value2_);
        }
        throwInvalidOperation();
    }
};

class QCInt32Array : public QC {
    std::vector<int32_t> values_;

public:
    QCInt32Array(obx_schema_id propId, QueryOp op, std::vector<int32_t>&& values)
        : QC(propId, op), values_(std::move(values)) {}

protected:
    std::unique_ptr<QueryCondition> copyAsPtr() const override { return QueryCondition::copyAsPtr(*this); };

    obx_qb_cond applyTo(OBX_query_builder* cqb, bool) const override {
        if (op_ == QueryOp::In) {
            return obx_qb_in_int32s(cqb, propId_, values_.data(), values_.size());
        } else if (op_ == QueryOp::NotIn) {
            return obx_qb_not_in_int32s(cqb, propId_, values_.data(), values_.size());
        }
        throwInvalidOperation();
    }
};

class QCInt64Array : public QC {
    std::vector<int64_t> values_;

public:
    QCInt64Array(obx_schema_id propId, QueryOp op, std::vector<int64_t>&& values)
        : QC(propId, op), values_(std::move(values)) {}

protected:
    std::unique_ptr<QueryCondition> copyAsPtr() const override { return QueryCondition::copyAsPtr(*this); };

    obx_qb_cond applyTo(OBX_query_builder* cqb, bool) const override {
        if (op_ == QueryOp::In) {
            return obx_qb_in_int64s(cqb, propId_, values_.data(), values_.size());
        } else if (op_ == QueryOp::NotIn) {
            return obx_qb_not_in_int64s(cqb, propId_, values_.data(), values_.size());
        }
        throwInvalidOperation();
    }
};

template <OBXPropertyType PropertyType>
class QCString : public QC {
    std::string value_;
    bool caseSensitive_;

public:
    QCString(obx_schema_id propId, QueryOp op, bool caseSensitive, std::string&& value)
        : QC(propId, op), caseSensitive_(caseSensitive), value_(std::move(value)) {}

protected:
    std::unique_ptr<QueryCondition> copyAsPtr() const override { return QueryCondition::copyAsPtr(*this); };

    obx_qb_cond applyTo(OBX_query_builder* cqb, bool) const override {
        if (PropertyType == OBXPropertyType_String) {
            if (op_ == QueryOp::Equal) {
                return obx_qb_equals_string(cqb, propId_, value_.c_str(), caseSensitive_);
            } else if (op_ == QueryOp::NotEqual) {
                return obx_qb_not_equals_string(cqb, propId_, value_.c_str(), caseSensitive_);
            } else if (op_ == QueryOp::Less) {
                return obx_qb_less_than_string(cqb, propId_, value_.c_str(), caseSensitive_);
            } else if (op_ == QueryOp::LessOrEq) {
                return obx_qb_less_or_equal_string(cqb, propId_, value_.c_str(), caseSensitive_);
            } else if (op_ == QueryOp::Greater) {
                return obx_qb_greater_than_string(cqb, propId_, value_.c_str(), caseSensitive_);
            } else if (op_ == QueryOp::GreaterOrEq) {
                return obx_qb_greater_or_equal_string(cqb, propId_, value_.c_str(), caseSensitive_);
            } else if (op_ == QueryOp::StartsWith) {
                return obx_qb_starts_with_string(cqb, propId_, value_.c_str(), caseSensitive_);
            } else if (op_ == QueryOp::EndsWith) {
                return obx_qb_ends_with_string(cqb, propId_, value_.c_str(), caseSensitive_);
            } else if (op_ == QueryOp::Contains) {
                return obx_qb_contains_string(cqb, propId_, value_.c_str(), caseSensitive_);
            }
        } else if (PropertyType == OBXPropertyType_StringVector) {
            if (op_ == QueryOp::Contains) {
                return obx_qb_any_equals_string(cqb, propId_, value_.c_str(), caseSensitive_);
            }
        }
        throwInvalidOperation();
    }
};

using QCStringForString = QCString<OBXPropertyType_String>;
using QCStringForStringVector = QCString<OBXPropertyType_StringVector>;

class QCStringArray : public QC {
    std::vector<std::string> values_;  // stored string copies
    bool caseSensitive_;

public:
    QCStringArray(obx_schema_id propId, QueryOp op, bool caseSensitive, std::vector<std::string>&& values)
        : QC(propId, op), values_(std::move(values)), caseSensitive_(caseSensitive) {}

protected:
    std::unique_ptr<QueryCondition> copyAsPtr() const override { return QueryCondition::copyAsPtr(*this); };

    obx_qb_cond applyTo(OBX_query_builder* cqb, bool) const override {
        // don't make an instance variable - it's not trivially copyable by copyAsPtr() and is usually called just once
        std::vector<const char*> cvalues;
        cvalues.resize(values_.size());
        for (size_t i = 0; i < values_.size(); i++) {
            cvalues[i] = values_[i].c_str();
        }
        if (op_ == QueryOp::In) {
            return obx_qb_in_strings(cqb, propId_, cvalues.data(), cvalues.size(), caseSensitive_);
        }
        throwInvalidOperation();
    }
};

class QCBytes : public QC {
    std::vector<uint8_t> value_;

public:
    QCBytes(obx_schema_id propId, QueryOp op, std::vector<uint8_t>&& value)
        : QC(propId, op), value_(std::move(value)) {}

    QCBytes(obx_schema_id propId, QueryOp op, const void* data, size_t size)
        : QC(propId, op), value_(static_cast<const uint8_t*>(data), static_cast<const uint8_t*>(data) + size) {}

protected:
    std::unique_ptr<QueryCondition> copyAsPtr() const override { return QueryCondition::copyAsPtr(*this); };

    obx_qb_cond applyTo(OBX_query_builder* cqb, bool) const override {
        if (op_ == QueryOp::Equal) {
            return obx_qb_equals_bytes(cqb, propId_, value_.data(), value_.size());
        } else if (op_ == QueryOp::Less) {
            return obx_qb_less_than_bytes(cqb, propId_, value_.data(), value_.size());
        } else if (op_ == QueryOp::LessOrEq) {
            return obx_qb_less_or_equal_bytes(cqb, propId_, value_.data(), value_.size());
        } else if (op_ == QueryOp::Greater) {
            return obx_qb_greater_than_bytes(cqb, propId_, value_.data(), value_.size());
        } else if (op_ == QueryOp::GreaterOrEq) {
            return obx_qb_greater_or_equal_bytes(cqb, propId_, value_.data(), value_.size());
        }
        throwInvalidOperation();
    }
};

#ifndef OBX_DISABLE_FLATBUFFERS
// FlatBuffer builder is reused so the allocated memory stays available for the future objects.
thread_local flatbuffers::FlatBufferBuilder fbb;
inline void fbbCleanAfterUse() {
    if (fbb.GetSize() > 1024 * 1024) fbb.Reset();
}
#endif

// enable_if_t missing in c++11 so let's have a shorthand here
template <bool Condition, typename T = void>
using enable_if_t = typename std::enable_if<Condition, T>::type;

template <OBXPropertyType T, bool includingRelation = false>
using EnableIfInteger =
    enable_if_t<T == OBXPropertyType_Int || T == OBXPropertyType_Long || T == OBXPropertyType_Short ||
                T == OBXPropertyType_Short || T == OBXPropertyType_Byte || T == OBXPropertyType_Date ||
                T == OBXPropertyType_DateNano || (includingRelation && T == OBXPropertyType_Relation)>;

template <OBXPropertyType T>
using EnableIfIntegerOrRel = EnableIfInteger<T, true>;

template <OBXPropertyType T>
using EnableIfFloating = enable_if_t<T == OBXPropertyType_Float || T == OBXPropertyType_Double>;

template <OBXPropertyType T>
using EnableIfDate = enable_if_t<T == OBXPropertyType_Date || T == OBXPropertyType_DateNano>;

static constexpr OBXPropertyType typeless = OBXPropertyType(0);
}  // namespace

/// "Typeless" property used as a base class for other types - sharing common conditions.
template <typename EntityT>
class PropertyTypeless {
public:
    constexpr PropertyTypeless(obx_schema_id id) : id_(id) {}
    inline obx_schema_id id() const { return id_; }

    QC isNull() const { return {id_, QueryOp::Null}; }
    QC isNotNull() const { return {id_, QueryOp::NotNull}; }

protected:
    /// property ID
    const obx_schema_id id_;
};

/// Carries property information when used in the entity-meta ("underscore") class
template <typename EntityT, OBXPropertyType ValueT>
class Property : public PropertyTypeless<EntityT> {
public:
    constexpr Property(obx_schema_id id) : PropertyTypeless<EntityT>(id) {}

    template <OBXPropertyType T = ValueT, typename = enable_if_t<T == OBXPropertyType_Bool>>
    QCInt64 equals(bool value) const {
        return {this->id_, QueryOp::Equal, value};
    }

    template <OBXPropertyType T = ValueT, typename = enable_if_t<T == OBXPropertyType_Bool>>
    QCInt64 notEquals(bool value) const {
        return {this->id_, QueryOp::NotEqual, value};
    }

    template <OBXPropertyType T = ValueT, typename = EnableIfIntegerOrRel<T>>
    QCInt64 equals(int64_t value) const {
        return {this->id_, QueryOp::Equal, value};
    }

    template <OBXPropertyType T = ValueT, typename = EnableIfIntegerOrRel<T>>
    QCInt64 notEquals(int64_t value) const {
        return {this->id_, QueryOp::NotEqual, value};
    }

    template <OBXPropertyType T = ValueT, typename = EnableIfInteger<T>>
    QCInt64 lessThan(int64_t value) const {
        return {this->id_, QueryOp::Less, value};
    }

    template <OBXPropertyType T = ValueT, typename = EnableIfInteger<T>>
    QCInt64 lessOrEq(int64_t value) const {
        return {this->id_, QueryOp::LessOrEq, value};
    }

    template <OBXPropertyType T = ValueT, typename = EnableIfInteger<T>>
    QCInt64 greaterThan(int64_t value) const {
        return {this->id_, QueryOp::Greater, value};
    }

    template <OBXPropertyType T = ValueT, typename = EnableIfInteger<T>>
    QCInt64 greaterOrEq(int64_t value) const {
        return {this->id_, QueryOp::GreaterOrEq, value};
    }

    /// finds objects with property value between a and b (including a and b)
    template <OBXPropertyType T = ValueT, typename = EnableIfInteger<T>>
    QCInt64 between(int64_t a, int64_t b) const {
        return {this->id_, QueryOp::Between, a, b};
    }

    template <OBXPropertyType T = ValueT, typename = enable_if_t<T == OBXPropertyType_Int>>
    QCInt32Array in(std::vector<int32_t>&& values) const {
        return {this->id_, QueryOp::In, std::move(values)};
    }

    template <OBXPropertyType T = ValueT, typename = enable_if_t<T == OBXPropertyType_Int>>
    QCInt32Array in(const std::vector<int32_t>& values) const {
        return in(std::vector<int32_t>(values));
    }

    template <OBXPropertyType T = ValueT, typename = enable_if_t<T == OBXPropertyType_Int>>
    QCInt32Array notIn(std::vector<int32_t>&& values) const {
        return {this->id_, QueryOp::NotIn, std::move(values)};
    }

    template <OBXPropertyType T = ValueT, typename = enable_if_t<T == OBXPropertyType_Int>>
    QCInt32Array notIn(const std::vector<int32_t>& values) const {
        return notIn(std::vector<int32_t>(values));
    }

    template <OBXPropertyType T = ValueT,
              typename = enable_if_t<T == OBXPropertyType_Long || T == OBXPropertyType_Relation>>
    QCInt64Array in(std::vector<int64_t>&& values) const {
        return {this->id_, QueryOp::In, std::move(values)};
    }

    template <OBXPropertyType T = ValueT,
              typename = enable_if_t<T == OBXPropertyType_Long || T == OBXPropertyType_Relation>>
    QCInt64Array in(const std::vector<int64_t>& values) const {
        return in(std::vector<int64_t>(values));
    }

    template <OBXPropertyType T = ValueT,
              typename = enable_if_t<T == OBXPropertyType_Long || T == OBXPropertyType_Relation>>
    QCInt64Array notIn(std::vector<int64_t>&& values) const {
        return {this->id_, QueryOp::NotIn, std::move(values)};
    }

    template <OBXPropertyType T = ValueT,
              typename = enable_if_t<T == OBXPropertyType_Long || T == OBXPropertyType_Relation>>
    QCInt64Array notIn(const std::vector<int64_t>& values) const {
        return notIn(std::vector<int64_t>(values));
    }

    template <OBXPropertyType T = ValueT, typename = EnableIfFloating<T>>
    QCDouble lessThan(double value) const {
        return {this->id_, QueryOp::Less, value};
    }

    template <OBXPropertyType T = ValueT, typename = EnableIfFloating<T>>
    QCDouble lessOrEq(double value) const {
        return {this->id_, QueryOp::LessOrEq, value};
    }

    template <OBXPropertyType T = ValueT, typename = EnableIfFloating<T>>
    QCDouble greaterThan(double value) const {
        return {this->id_, QueryOp::Greater, value};
    }

    template <OBXPropertyType T = ValueT, typename = EnableIfFloating<T>>
    QCDouble greaterOrEq(double value) const {
        return {this->id_, QueryOp::GreaterOrEq, value};
    }

    /// finds objects with property value between a and b (including a and b)
    template <OBXPropertyType T = ValueT, typename = EnableIfFloating<T>>
    QCDouble between(double a, double b) const {
        return {this->id_, QueryOp::Between, a, b};
    }
};

/// Carries property information when used in the entity-meta ("underscore") class
template <typename EntityT>
class Property<EntityT, OBXPropertyType_String> : public PropertyTypeless<EntityT> {
public:
    constexpr Property(obx_schema_id id) : PropertyTypeless<EntityT>(id) {}

    QCStringForString equals(std::string&& value, bool caseSensitive = true) const {
        return {this->id_, QueryOp::Equal, caseSensitive, std::move(value)};
    }

    QCStringForString equals(const std::string& value, bool caseSensitive = true) const {
        return equals(std::string(value), caseSensitive);
    }

    QCStringForString notEquals(std::string&& value, bool caseSensitive = true) const {
        return {this->id_, QueryOp::NotEqual, caseSensitive, std::move(value)};
    }

    QCStringForString notEquals(const std::string& value, bool caseSensitive = true) const {
        return notEquals(std::string(value), caseSensitive);
    }

    QCStringForString lessThan(std::string&& value, bool caseSensitive = true) const {
        return {this->id_, QueryOp::Less, caseSensitive, std::move(value)};
    }

    QCStringForString lessThan(const std::string& value, bool caseSensitive = true) const {
        return lessThan(std::string(value), caseSensitive);
    }

    QCStringForString lessOrEq(std::string&& value, bool caseSensitive = true) const {
        return {this->id_, QueryOp::LessOrEq, caseSensitive, std::move(value)};
    }

    QCStringForString lessOrEq(const std::string& value, bool caseSensitive = true) const {
        return lessOrEq(std::string(value), caseSensitive);
    }

    QCStringForString greaterThan(std::string&& value, bool caseSensitive = true) const {
        return {this->id_, QueryOp::Greater, caseSensitive, std::move(value)};
    }

    QCStringForString greaterThan(const std::string& value, bool caseSensitive = true) const {
        return greaterThan(std::string(value), caseSensitive);
    }

    QCStringForString greaterOrEq(std::string&& value, bool caseSensitive = true) const {
        return {this->id_, QueryOp::GreaterOrEq, caseSensitive, std::move(value)};
    }

    QCStringForString greaterOrEq(const std::string& value, bool caseSensitive = true) const {
        return greaterOrEq(std::string(value), caseSensitive);
    }

    QCStringForString contains(std::string&& value, bool caseSensitive = true) const {
        return {this->id_, QueryOp::Contains, caseSensitive, std::move(value)};
    }

    QCStringForString contains(const std::string& value, bool caseSensitive = true) const {
        return contains(std::string(value), caseSensitive);
    }

    QCStringForString startsWith(std::string&& value, bool caseSensitive = true) const {
        return {this->id_, QueryOp::StartsWith, caseSensitive, std::move(value)};
    }

    QCStringForString startsWith(const std::string& value, bool caseSensitive = true) const {
        return startsWith(std::string(value), caseSensitive);
    }

    QCStringForString endsWith(std::string&& value, bool caseSensitive = true) const {
        return {this->id_, QueryOp::EndsWith, caseSensitive, std::move(value)};
    }

    QCStringForString endsWith(const std::string& value, bool caseSensitive = true) const {
        return endsWith(std::string(value), caseSensitive);
    }

    QCStringArray in(std::vector<std::string>&& values, bool caseSensitive = true) const {
        return {this->id_, QueryOp::In, caseSensitive, std::move(values)};
    }

    QCStringArray in(const std::vector<std::string>& values, bool caseSensitive = true) const {
        return in(std::vector<std::string>(values), caseSensitive);
    }
};

/// Carries property information when used in the entity-meta ("underscore") class
template <typename EntityT>
class Property<EntityT, OBXPropertyType_ByteVector> : public PropertyTypeless<EntityT> {
public:
    constexpr Property(obx_schema_id id) : PropertyTypeless<EntityT>(id) {}

    QCBytes equals(std::vector<uint8_t>&& data) const { return {this->id_, QueryOp::Equal, std::move(data)}; }

    QCBytes equals(const void* data, size_t size) const { return {this->id_, QueryOp::Equal, data, size}; }

    QCBytes equals(const std::vector<uint8_t>& data) const { return equals(std::vector<uint8_t>(data)); }

    QCBytes lessThan(std::vector<uint8_t>&& data) const { return {this->id_, QueryOp::Less, std::move(data)}; }

    QCBytes lessThan(const void* data, size_t size) const { return {this->id_, QueryOp::Less, data, size}; }

    QCBytes lessThan(const std::vector<uint8_t>& data) const { return lessThan(std::vector<uint8_t>(data)); }

    QCBytes lessOrEq(std::vector<uint8_t>&& data) const { return {this->id_, QueryOp::LessOrEq, std::move(data)}; }

    QCBytes lessOrEq(const void* data, size_t size) const { return {this->id_, QueryOp::LessOrEq, data, size}; }

    QCBytes lessOrEq(const std::vector<uint8_t>& data) const { return lessOrEq(std::vector<uint8_t>(data)); }

    QCBytes greaterThan(std::vector<uint8_t>&& data) const { return {this->id_, QueryOp::Greater, std::move(data)}; }

    QCBytes greaterThan(const void* data, size_t size) const { return {this->id_, QueryOp::Greater, data, size}; }

    QCBytes greaterThan(const std::vector<uint8_t>& data) const { return greaterThan(std::vector<uint8_t>(data)); }

    QCBytes greaterOrEq(std::vector<uint8_t>&& data) const {
        return {this->id_, QueryOp::GreaterOrEq, std::move(data)};
    }

    QCBytes greaterOrEq(const void* data, size_t size) const { return {this->id_, QueryOp::GreaterOrEq, data, size}; }

    QCBytes greaterOrEq(const std::vector<uint8_t>& data) const { return greaterOrEq(std::vector<uint8_t>(data)); }
};

/// Carries property information when used in the entity-meta ("underscore") class
template <typename EntityT>
class Property<EntityT, OBXPropertyType_StringVector> : public PropertyTypeless<EntityT> {
public:
    constexpr Property(obx_schema_id id) : PropertyTypeless<EntityT>(id) {}

    QCStringForStringVector contains(std::string&& value, bool caseSensitive = true) const {
        return {this->id_, QueryOp::Contains, caseSensitive, std::move(value)};
    }

    QCStringForStringVector contains(const std::string& value, bool caseSensitive = true) const {
        return contains(std::string(value), caseSensitive);
    }
};

/// Carries property-based to-one relation information when used in the entity-meta ("underscore") class
template <typename SourceEntityT, typename TargetEntityT>
class RelationProperty : public Property<SourceEntityT, OBXPropertyType_Relation> {
public:
    constexpr RelationProperty(obx_schema_id id) : Property<SourceEntityT, OBXPropertyType_Relation>(id) {}
};

/// Carries to-many relation information when used in the entity-meta ("underscore") class
template <typename SourceEntityT, typename TargetEntityT>
class RelationStandalone {
public:
    constexpr RelationStandalone(obx_schema_id id) : id_(id) {}
    inline obx_schema_id id() const { return id_; }

protected:
    /// standalone relation ID
    const obx_schema_id id_;
};

template <typename EntityT>
class Query;

/// Provides a simple wrapper for OBX_query_builder to simplify memory management - calls obx_qb_close() on destruction.
/// To specify actual conditions, use obx_qb_*() methods with queryBuilder.cPtr() as the first argument.
template <typename EntityT>
class QueryBuilder {
    using EntityBinding = typename EntityT::_OBX_MetaInfo;
    Store& store_;
    OBX_query_builder* cQueryBuilder_;
    bool isRoot_;

public:
    explicit QueryBuilder(Store& store)
        : QueryBuilder(store, obx_query_builder(store.cPtr(), EntityBinding::entityId()), true) {}

    /// Take ownership of an OBX_query_builder.
    ///
    /// *Example:**
    ///
    ///          QueryBuilder innerQb(obx_qb_link_property(outerQb.cPtr(), linkPropertyId), false)
    explicit QueryBuilder(Store& store, OBX_query_builder* ptr, bool isRoot)
        : store_(store), cQueryBuilder_(ptr), isRoot_(isRoot) {
        checkPtrOrThrow(cQueryBuilder_, "can't create a query builder");
    }

    /// Can't be copied, single owner of C resources is required (to avoid double-free during destruction)
    QueryBuilder(const QueryBuilder&) = delete;

    QueryBuilder(QueryBuilder&& source) noexcept
        : store_(source.store_), cQueryBuilder_(source.cQueryBuilder_), isRoot_(source.isRoot_) {
        source.cQueryBuilder_ = nullptr;
    }

    virtual ~QueryBuilder() { obx_qb_close(cQueryBuilder_); }

    OBX_query_builder* cPtr() const { return cQueryBuilder_; }

    /// Adds an order based on a given property.
    /// @param property the property used for the order
    /// @param flags combination of OBXOrderFlags
    /// @return the reference to the same QueryBuilder for fluent interface.
    template <OBXPropertyType PropType>
    QueryBuilder& order(Property<EntityT, PropType> property, int flags = 0) {
        checkErrOrThrow(obx_qb_order(cQueryBuilder_, property.id(), OBXOrderFlags(flags)));
        return *this;
    }

    /// Appends given condition/combination of conditions.
    /// @return the reference to the same QueryBuilder for fluent interface.
    QueryBuilder& with(const QueryCondition& condition) {
        internalApplyCondition(condition, cQueryBuilder_, true);
        return *this;
    }

    /// Links the (time series) entity type to another entity space using a time point in a linked entity.
    /// \note 1) Time series functionality (ObjectBox TS) must be available to use this.
    /// \note 2) Returned QueryBuilder switches context, make sure to call build() on the root QueryBuilder.
    /// @param property Property of the linked entity defining a time point or the begin of a time range.
    ///        Must be a date type (e.g. PropertyType_Date or PropertyType_DateNano).
    /// @return the linked QueryBuilder; "switches context" to the linked entity.
    template <typename RangePropertyEntityT, OBXPropertyType RangePropertyType,
              typename = EnableIfDate<RangePropertyType>>
    QueryBuilder<RangePropertyEntityT> linkTime(Property<RangePropertyEntityT, RangePropertyType> property) {
        return linkedQB<RangePropertyEntityT>(
            obx_qb_link_time(cPtr(), entityId<RangePropertyEntityT>(), property.id(), 0));
    }

    /// Links the (time series) entity type to another entity space using a range defined in a given linked entity.
    /// \note 1) Time series functionality (ObjectBox TS) must be available to use this.
    /// \note 2) Returned QueryBuilder switches context, make sure to call build() on the root QueryBuilder.
    /// @param beginProperty Property of the linked entity defining the beginning of a time range.
    ///        Must be a date type (e.g. PropertyType_Date or PropertyType_DateNano).
    /// @param endProperty Property of the linked entity defining the end of a time range.
    ///        Must be a date type (e.g. PropertyType_Date or PropertyType_DateNano).
    /// @return the linked QueryBuilder; "switches context" to the linked entity.
    template <typename RangePropertyEntityT, OBXPropertyType RangePropertyType,
              typename = EnableIfDate<RangePropertyType>>
    QueryBuilder<RangePropertyEntityT> linkTime(Property<RangePropertyEntityT, RangePropertyType> beginProperty,
                                                Property<RangePropertyEntityT, RangePropertyType> endProperty) {
        return linkedQB<RangePropertyEntityT>(
            obx_qb_link_time(cPtr(), entityId<RangePropertyEntityT>(), beginProperty.id(), endProperty.id()));
    }

    /// Create a link based on a property-relation (to-one).
    /// \note Returned QueryBuilder switches context, make sure to call build() on the root QueryBuilder.
    /// @param rel the relation property, with source EntityT represented by this QueryBuilder.
    /// @param condition a condition or a group of conditions to apply on the linked entity
    /// @return the linked QueryBuilder; "switches context" to the linked entity.
    template <typename RelTargetEntityT>
    QueryBuilder<RelTargetEntityT> link(RelationProperty<EntityT, RelTargetEntityT> rel) {
        return linkedQB<RelTargetEntityT>(obx_qb_link_property(cPtr(), rel.id()));
    }

    /// Create a backlink based on a property-relation used in reverse (to-many).
    /// \note Returned QueryBuilder switches context, make sure to call build() on the root QueryBuilder.
    /// @param rel the relation property, with target EntityT represented by this QueryBuilder.
    /// @return the linked QueryBuilder; "switches context" to the linked entity.
    template <typename RelSourceEntityT>
    QueryBuilder<RelSourceEntityT> backlink(RelationProperty<RelSourceEntityT, EntityT> rel) {
        return linkedQB<RelSourceEntityT>(obx_qb_backlink_property(cPtr(), entityId<RelSourceEntityT>(), rel.id()));
    }

    /// Create a link based on a standalone relation (many-to-many)
    /// \note Returned QueryBuilder switches context, make sure to call build() on the root QueryBuilder.
    /// @return the linked QueryBuilder; "switches context" to the linked entity.
    template <typename RelTargetEntityT>
    QueryBuilder<RelTargetEntityT> link(RelationStandalone<EntityT, RelTargetEntityT> rel) {
        return linkedQB<RelTargetEntityT>(obx_qb_link_standalone(cPtr(), rel.id()));
    }

    /// Create a backlink based on a standalone relation (many-to-many, reverse direction)
    /// \note Returned QueryBuilder switches context, make sure to call build() on the root QueryBuilder.
    /// @return the linked QueryBuilder; "switches context" to the linked entity.
    template <typename RelSourceEntityT>
    QueryBuilder<RelSourceEntityT> backlink(RelationStandalone<RelSourceEntityT, EntityT> rel) {
        return linkedQB<RelSourceEntityT>(obx_qb_backlink_standalone(cPtr(), rel.id()));
    }

    Query<EntityT> build();

protected:
    template <typename LinkedEntityT>
    QueryBuilder<LinkedEntityT> linkedQB(OBX_query_builder* linkedQB) {
        checkPtrOrThrow(linkedQB, "can't build a query link");
        // NOTE: linkedQB may be lost if the user doesn't keep the returned sub-builder around and that's fine.
        // We're relying on the C-API keeping track of sub-builders on the root QB.
        return QueryBuilder<LinkedEntityT>(store_, linkedQB, false);
    }
};

/// Provides a simple wrapper for OBX_query to simplify memory management - calls obx_query_close() on destruction.
/// To execute the actual methods, use obx_query_*() methods with query.cPtr() as the first argument.
/// Internal note: this is a template because it will provide EntityType-specific methods in the future
template <typename EntityT>
class Query {
    OBX_query* cQuery_;
    Store& store_;

public:
    /// Builds a query with the parameters specified by the builder
    explicit Query(Store& store, OBX_query_builder* qb) : cQuery_(obx_query(qb)), store_(store) {
        checkPtrOrThrow(cQuery_, "can't build a query");
    }

    /// Clones the query
    Query(const Query& query) : cQuery_(obx_query_clone(query.cQuery_)), store_(query.store_) {
        checkPtrOrThrow(cQuery_, "couldn't make a query clone");
    }

    Query(Query&& source) noexcept : cQuery_(source.cQuery_), store_(source.store_) { source.cQuery_ = nullptr; }

    virtual ~Query() { obx_query_close(cQuery_); }

    OBX_query* cPtr() const { return cQuery_; }

    /// Sets an offset of what items to start at.
    /// This offset is stored for any further calls on the query until changed.
    /// Call with offset=0 to reset to the default behavior, i.e. starting from the first element.
    Query& offset(size_t offset) {
        checkErrOrThrow(obx_query_offset(cQuery_, offset));
        return *this;
    }

    /// Sets a limit on the number of processed items.
    /// This limit is stored for any further calls on the query until changed.
    /// Call with limit=0 to reset to the default behavior - zero limit means no limit applied.
    Query& limit(size_t limit) {
        checkErrOrThrow(obx_query_limit(cQuery_, limit));
        return *this;
    }

    /// Finds all objects matching the query.
    /// Note: returning a vector of pointers to avoid excessive allocation because we don't know the number of returned
    /// objects beforehand.
    std::vector<std::unique_ptr<EntityT>> find() {
        OBJECTBOX_VERIFY_STATE(cQuery_ != nullptr);

        CollectingVisitor<EntityT> visitor;
        obx_query_visit(cQuery_, CollectingVisitor<EntityT>::visit, &visitor);
        return std::move(visitor.items);
    }

    /// Find the first object matching the query or nullptr if none matches.
    std::unique_ptr<EntityT> findFirst() {
        return findSingle<std::unique_ptr<EntityT>>(obx_query_find_first, EntityT::_OBX_MetaInfo::newFromFlatBuffer);
    }

    /// Find the only object matching the query.
    /// @throws if there are multiple objects matching the query
    std::unique_ptr<EntityT> findUnique() {
        return findSingle<std::unique_ptr<EntityT>>(obx_query_find_unique, EntityT::_OBX_MetaInfo::newFromFlatBuffer);
    }

#ifdef __cpp_lib_optional
    /// Find the first object matching the query or nullptr if none matches.
    std::optional<EntityT> findFirstOptional() {
        return findSingle<std::optional<EntityT>>(obx_query_find_first, EntityT::_OBX_MetaInfo::fromFlatBuffer);
    }

    /// Find the only object matching the query.
    /// @throws if there are multiple objects matching the query
    std::optional<EntityT> findUniqueOptional() {
        return findSingle<std::optional<EntityT>>(obx_query_find_unique, EntityT::_OBX_MetaInfo::fromFlatBuffer);
    }
#endif

    /// Returns IDs of all matching objects.
    std::vector<obx_id> findIds() { return idVectorOrThrow(obx_query_find_ids(cQuery_)); }

    /// Returns the number of matching objects.
    uint64_t count() {
        uint64_t result;
        checkErrOrThrow(obx_query_count(cQuery_, &result));
        return result;
    }

    /// Removes all matching objects from the database & returns the number of deleted objects.
    size_t remove() {
        uint64_t result;
        checkErrOrThrow(obx_query_remove(cQuery_, &result));
        return result;
    }

    /// Change previously set condition value in an existing query - this improves reusability of the query object.
    template <
        typename PropertyEntityT, OBXPropertyType PropertyType,
        typename = enable_if_t<PropertyType == OBXPropertyType_String || PropertyType == OBXPropertyType_StringVector>>
    Query& setParameter(Property<PropertyEntityT, PropertyType> property, const char* value) {
        checkErrOrThrow(obx_query_param_string(cQuery_, entityId<PropertyEntityT>(), property.id(), value));
        return *this;
    }

    /// Change previously set condition value in an existing query - this improves reusability of the query object.
    template <
        typename PropertyEntityT, OBXPropertyType PropertyType,
        typename = enable_if_t<PropertyType == OBXPropertyType_String || PropertyType == OBXPropertyType_StringVector>>
    Query& setParameter(Property<PropertyEntityT, PropertyType> property, const std::string& value) {
        return setParameter(property, value.c_str());
    }

    /// Change previously set condition value in an existing query - this improves reusability of the query object.
    template <typename PropertyEntityT>
    Query& setParameter(Property<PropertyEntityT, OBXPropertyType_String> property, const char* const values[],
                        size_t count) {
        checkErrOrThrow(obx_query_param_strings(cQuery_, entityId<PropertyEntityT>(), property.id(), values, count));
        return *this;
    }

    /// Change previously set condition value in an existing query - this improves reusability of the query object.
    template <typename PropertyEntityT>
    Query& setParameter(Property<PropertyEntityT, OBXPropertyType_String> property,
                        const std::vector<const char*>& values) {
        return setParameter(property, values.data(), values.size());
    }

    /// Change previously set condition value in an existing query - this improves reusability of the query object.
    template <typename PropertyEntityT>
    Query& setParameter(Property<PropertyEntityT, OBXPropertyType_String> property,
                        const std::vector<std::string>& values) {
        std::vector<const char*> cValues;
        cValues.reserve(values.size());
        for (const std::string& str : values) {
            cValues.push_back(str.c_str());
        }
        return setParameter(property, cValues.data(), cValues.size());
    }

    /// Change previously set condition value in an existing query - this improves reusability of the query object.
    template <typename PropertyEntityT>
    Query& setParameter(Property<PropertyEntityT, OBXPropertyType_Bool> property, bool value) {
        checkErrOrThrow(obx_query_param_int(cQuery_, entityId<PropertyEntityT>(), property.id(), value));
        return *this;
    }

    /// Change previously set condition value in an existing query - this improves reusability of the query object.
    template <typename PropertyEntityT, OBXPropertyType PropertyType, typename = EnableIfIntegerOrRel<PropertyType>>
    Query& setParameter(Property<PropertyEntityT, PropertyType> property, int64_t value) {
        checkErrOrThrow(obx_query_param_int(cQuery_, entityId<PropertyEntityT>(), property.id(), value));
        return *this;
    }

    /// Change previously set condition value in an existing query - this improves reusability of the query object.
    template <typename PropertyEntityT, OBXPropertyType PropertyType, typename = EnableIfIntegerOrRel<PropertyType>>
    Query& setParameters(Property<PropertyEntityT, PropertyType> property, int64_t valueA, int64_t valueB) {
        checkErrOrThrow(obx_query_param_2ints(cQuery_, entityId<PropertyEntityT>(), property.id(), valueA, valueB));
        return *this;
    }

    /// Change previously set condition value in an existing query - this improves reusability of the query object.
    template <typename PropertyEntityT, OBXPropertyType PropertyType,
              typename = enable_if_t<PropertyType == OBXPropertyType_Long || PropertyType == OBXPropertyType_Relation>>
    Query& setParameter(Property<PropertyEntityT, PropertyType> property, const std::vector<int64_t>& values) {
        checkErrOrThrow(
            obx_query_param_int64s(cQuery_, entityId<PropertyEntityT>(), property.id(), values.data(), values.size()));
        return *this;
    }

    /// Change previously set condition value in an existing query - this improves reusability of the query object.
    template <typename PropertyEntityT, OBXPropertyType PropertyType,
              typename = enable_if_t<PropertyType == OBXPropertyType_Int>>
    Query& setParameter(Property<PropertyEntityT, PropertyType> property, const std::vector<int32_t>& values) {
        checkErrOrThrow(
            obx_query_param_int32s(cQuery_, entityId<PropertyEntityT>(), property.id(), values.data(), values.size()));
        return *this;
    }

    /// Change previously set condition value in an existing query - this improves reusability of the query object.
    template <typename PropertyEntityT, OBXPropertyType PropertyType, typename = EnableIfFloating<PropertyType>>
    Query& setParameter(Property<PropertyEntityT, PropertyType> property, double value) {
        checkErrOrThrow(obx_query_param_double(cQuery_, entityId<PropertyEntityT>(), property.id(), value));
        return *this;
    }

    /// Change previously set condition value in an existing query - this improves reusability of the query object.
    template <typename PropertyEntityT, OBXPropertyType PropertyType, typename = EnableIfFloating<PropertyType>>
    Query& setParameters(Property<PropertyEntityT, PropertyType> property, double valueA, double valueB) {
        checkErrOrThrow(obx_query_param_2doubles(cQuery_, entityId<PropertyEntityT>(), property.id(), valueA, valueB));
        return *this;
    }

    /// Change previously set condition value in an existing query - this improves reusability of the query object.
    template <typename PropertyEntityT>
    Query& setParameter(Property<PropertyEntityT, OBXPropertyType_ByteVector> property, const void* value,
                        size_t size) {
        checkErrOrThrow(obx_query_param_bytes(cQuery_, entityId<PropertyEntityT>(), property.id(), value, size));
        return *this;
    }

    /// Change previously set condition value in an existing query - this improves reusability of the query object.
    template <typename PropertyEntityT>
    Query& setParameter(Property<PropertyEntityT, OBXPropertyType_ByteVector> property,
                        const std::vector<uint8_t>& value) {
        return setParameter(property, value.data(), value.size());
    }

private:
    template <typename RET, typename T>
    RET findSingle(obx_err nativeFn(OBX_query*, const void**, size_t*), T fromFlatBuffer(const void*, size_t)) {
        OBJECTBOX_VERIFY_STATE(cQuery_ != nullptr);
        Transaction tx = store_.txRead();
        const void* data;
        size_t size;
        obx_err err = nativeFn(cQuery_, &data, &size);
        if (err == OBX_NOT_FOUND) return RET();
        checkErrOrThrow(err);
        return fromFlatBuffer(data, size);
    }
};

template <typename EntityT>
inline Query<EntityT> QueryBuilder<EntityT>::build() {
    OBJECTBOX_VERIFY_STATE(isRoot_);
    return Query<EntityT>(store_, cQueryBuilder_);
}

template <typename EntityT>
class Box {
    friend AsyncBox<EntityT>;
    using EntityBinding = typename EntityT::_OBX_MetaInfo;

    Store& store_;
    OBX_box* cBox_;

public:
    explicit Box(Store& store) : store_(store), cBox_(obx_box(store.cPtr(), EntityBinding::entityId())) {
        checkPtrOrThrow(cBox_, "can't create box");
    }

    OBX_box* cPtr() const { return cBox_; }

    /// Async operations are available through the AsyncBox class.
    /// @returns a shared AsyncBox instance with the default timeout (1s) for enqueueing.
    /// Note: while this looks like it creates a new instance, it's only a thin wrapper and the actual ObjectBox core
    /// internal async box really is shared.
    AsyncBox<EntityT> async() { return AsyncBox<EntityT>(*this); }

    /// Start building a query this entity.
    QueryBuilder<EntityT> query() { return QueryBuilder<EntityT>(store_); }

    /// Start building a query this entity.
    QueryBuilder<EntityT> query(const QueryCondition& condition) {
        QueryBuilder<EntityT> qb(store_);
        internalApplyCondition(condition, qb.cPtr(), true);
        return qb;
    }

    /// Return the number of objects contained by this box.
    /// @param limit if provided: stop counting at the given limit - useful if you need to make sure the Box has "at
    /// least" this many objects but you don't need to know the exact number.
    uint64_t count(uint64_t limit = 0) {
        uint64_t result;
        checkErrOrThrow(obx_box_count(cBox_, limit, &result));
        return result;
    }

    /// Returns true if the box contains no objects.
    bool isEmpty() {
        bool result;
        checkErrOrThrow(obx_box_is_empty(cBox_, &result));
        return result;
    }

    /// Checks whether this box contains an object with the given ID.
    bool contains(obx_id id) {
        bool result;
        checkErrOrThrow(obx_box_contains(cBox_, id, &result));
        return result;
    }

    /// Checks whether this box contains all objects matching the given IDs.
    bool contains(const std::vector<obx_id>& ids) {
        if (ids.empty()) return true;

        bool result;
        const OBX_id_array cIds = cIdArrayRef(ids);
        checkErrOrThrow(obx_box_contains_many(cBox_, &cIds, &result));
        return result;
    }

    /// Read an object from the database, returning a managed pointer.
    /// @return an object pointer or nullptr if an object with the given ID doesn't exist.
    std::unique_ptr<EntityT> get(obx_id id) {
        auto object = std::unique_ptr<EntityT>(new EntityT());
        if (!get(id, *object)) return nullptr;
        return object;
    }

    /// Read an object from the database, replacing the contents of an existing object variable.
    /// @return true on success, false if the ID was not found, in which case outObject is untouched.
    bool get(obx_id id, EntityT& outObject) {
        CursorTx cursor(TxMode::READ, store_, EntityBinding::entityId());
        const void* data;
        size_t size;
        obx_err err = obx_cursor_get(cursor.cPtr(), id, &data, &size);
        if (err == OBX_NOT_FOUND) return false;
        checkErrOrThrow(err);
        EntityBinding::fromFlatBuffer(data, size, outObject);
        return true;
    }

#ifdef __cpp_lib_optional
    /// Read an object from the database.
    /// @return an "optional" wrapper of the object; empty if an object with the given ID doesn't exist.
    std::optional<EntityT> getOptional(obx_id id) {
        CursorTx cursor(TxMode::READ, store_, EntityBinding::entityId());
        const void* data;
        size_t size;
        obx_err err = obx_cursor_get(cursor.cPtr(), id, &data, &size);
        if (err == OBX_NOT_FOUND) return std::nullopt;
        checkErrOrThrow(err);
        return EntityBinding::fromFlatBuffer(data, size);
    }
#endif

    /// Read multiple objects at once, i.e. in a single read transaction.
    /// @return a vector of object pointers index-matching the given ids. In case some objects are
    /// not found, it's position in the result will be NULL, thus the result will always have the
    /// same size as the given ids argument.
    std::vector<std::unique_ptr<EntityT>> get(const std::vector<obx_id>& ids) {
        return getMany<std::unique_ptr<EntityT>>(ids);
    }

#ifdef __cpp_lib_optional
    /// Read multiple objects at once, i.e. in a single read transaction.
    /// @return a vector of object pointers index-matching the given ids. In case some objects are
    /// not found, it's position in the result will be empty, thus the result will always have the
    /// same size as the given ids argument.
    std::vector<std::optional<EntityT>> getOptional(const std::vector<obx_id>& ids) {
        return getMany<std::optional<EntityT>>(ids);
    }
#endif

    /// Read all objects from the Box at once, i.e. in a single read transaction.
    std::vector<std::unique_ptr<EntityT>> getAll() {
        std::vector<std::unique_ptr<EntityT>> result;

        CursorTx cursor(TxMode::READ, store_, EntityBinding::entityId());
        const void* data;
        size_t size;

        obx_err err = obx_cursor_first(cursor.cPtr(), &data, &size);
        while (err == OBX_SUCCESS) {
            result.emplace_back(new EntityT());
            EntityBinding::fromFlatBuffer(data, size, *(result[result.size() - 1]));
            err = obx_cursor_next(cursor.cPtr(), &data, &size);
        }
        if (err != OBX_NOT_FOUND) checkErrOrThrow(err);

        return result;
    }

#ifndef OBX_DISABLE_FLATBUFFERS

    /// Inserts or updates the given object in the database.
    /// @param object will be updated with a newly inserted ID if the one specified previously was zero. If an ID was
    /// already specified (non-zero), it will remain unchanged.
    /// @return object ID from the object param (see object param docs).
    obx_id put(EntityT& object, OBXPutMode mode = OBXPutMode_PUT) {
        obx_id id = put(const_cast<const EntityT&>(object), mode);
        EntityBinding::setObjectId(object, id);
        return id;
    }

    /// Inserts or updates the given object in the database.
    /// @return newly assigned object ID in case this was an insert, otherwise the original ID from the object param.
    obx_id put(const EntityT& object, OBXPutMode mode = OBXPutMode_PUT) {
        EntityBinding::toFlatBuffer(fbb, object);
        obx_id id = obx_box_put_object4(cBox_, fbb.GetBufferPointer(), fbb.GetSize(), mode);
        fbbCleanAfterUse();
        if (id == 0) throwLastError();
        return id;
    }

    /// Puts multiple objects using a single transaction. In case there was an error the transaction is rolled back and
    /// none of the changes are persisted.
    /// @param objects objects to insert (if their IDs are zero) or update. ID properties on the newly inserted objects
    /// will be updated. If the transaction fails, the assigned IDs on the given objects will be incorrect.
    /// @param outIds may be provided to collect IDs from the objects. This collects not only new IDs assigned after an
    /// insert but also existing IDs if an object isn't new but updated instead. Thus, the outIds vector will always end
    /// up with the same number of items as objects argument, with indexes corresponding between the two. Note: outIds
    /// content is reset before executing to make sure the indexes match the objects argument even if outIds is reused
    /// between multiple calls.
    /// @throws reverts the changes if an error occurs.
    /// @return the number of put elements (always equal to objects.size() for this overload)
    size_t put(std::vector<EntityT>& objects, std::vector<obx_id>* outIds = nullptr, OBXPutMode mode = OBXPutMode_PUT) {
        return putMany(objects, outIds, mode);
    }

    /// @overload
    /// @return the number of put elements (always equal to objects.size() for this overload)
    size_t put(const std::vector<EntityT>& objects, std::vector<obx_id>* outIds = nullptr,
               OBXPutMode mode = OBXPutMode_PUT) {
        return putMany(objects, outIds, mode);
    }

    /// @overload
    /// @return the number of put elements, i.e. the number of std::unique_ptr != nullptr
    size_t put(std::vector<std::unique_ptr<EntityT>>& objects, std::vector<obx_id>* outIds = nullptr,
               OBXPutMode mode = OBXPutMode_PUT) {
        return putMany(objects, outIds, mode);
    }

#ifdef __cpp_lib_optional
    /// @overload
    /// @return the number of put elements, i.e. the number of items with std::optional::has_value() == true
    size_t put(std::vector<std::optional<EntityT>>& objects, std::vector<obx_id>* outIds = nullptr,
               OBXPutMode mode = OBXPutMode_PUT) {
        return putMany(objects, outIds, mode);
    }
#endif

#endif  // OBX_DISABLE_FLATBUFFERS

    /// Remove the object with the given id
    /// @returns whether the object was removed or not (because it didn't exist)
    bool remove(obx_id id) {
        obx_err err = obx_box_remove(cBox_, id);
        if (err == OBX_NOT_FOUND) return false;
        checkErrOrThrow(err);
        return true;
    }

    /// Removes all objects matching the given IDs
    /// @returns number of removed objects between 0 and ids.size() (if all IDs existed)
    uint64_t remove(const std::vector<obx_id>& ids) {
        uint64_t result = 0;
        const OBX_id_array cIds = cIdArrayRef(ids);
        checkErrOrThrow(obx_box_remove_many(cBox_, &cIds, &result));
        return result;
    }

    /// Removes all objects from the box
    /// @returns the number of removed objects
    uint64_t removeAll() {
        uint64_t result = 0;
        checkErrOrThrow(obx_box_remove_all(cBox_, &result));
        return result;
    }

    /// Fetch IDs of all objects in this box that reference the given object (ID) on the given relation property.
    /// Note: This method refers to "property based relations" unlike the "stand-alone relations" (Box::standaloneRel*).
    /// @param toOneRel the relation property, which must belong to the entity type represented by this box.
    /// @param objectId this relation points to - typically ID of an object of another entity type (another box).
    /// @returns resulting IDs representing objects in this Box, or NULL in case of an error
    ///
    /// **Example** Let's say you have the following two entities with a relation between them (.fbs file format):
    ///
    ///          table Customer {
    ///              id:ulong;
    ///              name:string;
    ///              ...
    ///          }
    ///          table Order {
    ///              id:ulong;
    ///              /// objectbox:link=Customer
    ///              customerId:ulong;
    ///              ...
    ///          }
    ///          Now, you can use this method to get all orders for a given customer (e.g. 42):
    ///          obx_id customerId = 42;
    ///          Box<Order_> orderBox(store);
    ///          std::vector<obx_id> customerOrders = orderBox.backlinkIds(Order_.customerId, 42);
    template <typename SourceEntityT, typename TargetEntityT>
    std::vector<obx_id> backlinkIds(RelationProperty<SourceEntityT, TargetEntityT> toOneRel, obx_id objectId) {
        static_assert(std::is_same<SourceEntityT, EntityT>::value,
                      "Given property (to-one relation) doesn't belong to this box - entity type mismatch");
        return idVectorOrThrow(obx_box_get_backlink_ids(cBox_, toOneRel.id(), objectId));
    }

    /// Replace the list of standalone relation target objects on the given source object.
    /// @param toManyRel must be a standalone relation ID with source object entity belonging to this box
    /// @param sourceObjectId identifies an object from this box
    /// @param targetObjectIds identifies objects from a target box (as per the relation definition)
    /// @todo consider providing a method similar to the one in Go - inserting target objects with 0 IDs
    template <typename SourceEntityT, typename TargetEntityT>
    void standaloneRelReplace(RelationStandalone<SourceEntityT, TargetEntityT> toManyRel, obx_id sourceObjectId,
                              const std::vector<obx_id>& targetObjectIds) {
        static_assert(std::is_same<SourceEntityT, EntityT>::value,
                      "Given relation (to-many) source entity must be the same as this box entity");

        // we use set_difference below so need to work on sorted vectors, thus we need to make a copy
        auto newIds = targetObjectIds;
        std::sort(newIds.begin(), newIds.end());

        Transaction tx(store_, TxMode::WRITE);

        auto oldIds = standaloneRelIds(toManyRel, sourceObjectId);
        std::sort(oldIds.begin(), oldIds.end());

        // find IDs to remove, i.e. those that previously were present and aren't anymore
        std::vector<obx_id> diff;
        std::set_difference(oldIds.begin(), oldIds.end(), newIds.begin(), newIds.end(),
                            std::inserter(diff, diff.begin()));

        for (obx_id targetId : diff) {
            standaloneRelRemove(toManyRel, sourceObjectId, targetId);
        }
        diff.clear();

        // find IDs to insert, i.e. those that previously weren't present and are now
        std::set_difference(newIds.begin(), newIds.end(), oldIds.begin(), oldIds.end(),
                            std::inserter(diff, diff.begin()));
        for (obx_id targetId : diff) {
            standaloneRelPut(toManyRel, sourceObjectId, targetId);
        }

        tx.success();
    }

    /// Insert a standalone relation entry between two objects.
    /// @param toManyRel must be a standalone relation ID with source object entity belonging to this box
    /// @param sourceObjectId identifies an object from this box
    /// @param targetObjectId identifies an object from a target box (as per the relation definition)
    template <typename TargetEntityT>
    void standaloneRelPut(RelationStandalone<EntityT, TargetEntityT> toManyRel, obx_id sourceObjectId,
                          obx_id targetObjectId) {
        checkErrOrThrow(obx_box_rel_put(cBox_, toManyRel.id(), sourceObjectId, targetObjectId));
    }

    /// Remove a standalone relation entry between two objects.
    /// @param toManyRel must be a standalone relation ID with source object entity belonging to this box
    /// @param sourceObjectId identifies an object from this box
    /// @param targetObjectId identifies an object from a target box (as per the relation definition)
    template <typename TargetEntityT>
    void standaloneRelRemove(RelationStandalone<EntityT, TargetEntityT> toManyRel, obx_id sourceObjectId,
                             obx_id targetObjectId) {
        checkErrOrThrow(obx_box_rel_remove(cBox_, toManyRel.id(), sourceObjectId, targetObjectId));
    }

    /// Fetch IDs of all objects in this Box related to the given object (typically from another Box).
    /// Used for a stand-alone relation and its "regular" direction; this Box represents the target of the relation.
    /// @param relationId ID of a standalone relation, whose target type matches this Box
    /// @param objectId object ID of the relation source type (typically from another Box)
    /// @returns resulting IDs representing objects in this Box
    /// @todo improve docs by providing an example with a clear distinction between source and target type
    template <typename SourceEntityT>
    std::vector<obx_id> standaloneRelIds(RelationStandalone<SourceEntityT, EntityT> toManyRel, obx_id objectId) {
        return idVectorOrThrow(obx_box_rel_get_ids(cBox_, toManyRel.id(), objectId));
    }

    /// Fetch IDs of all objects in this Box related to the given object (typically from another Box).
    /// Used for a stand-alone relation and its "backlink" direction; this Box represents the source of the relation.
    /// @param relationId ID of a standalone relation, whose source type matches this Box
    /// @param objectId object ID of the relation target type (typically from another Box)
    /// @returns resulting IDs representing objects in this Box
    template <typename TargetEntityT>
    std::vector<obx_id> standaloneRelBacklinkIds(RelationStandalone<EntityT, TargetEntityT> toManyRel,
                                                 obx_id objectId) {
        return idVectorOrThrow(obx_box_rel_get_backlink_ids(cBox_, toManyRel.id(), objectId));
    }

    /// Time series: get the limits (min/max time values) over all objects
    /// @param outMinId pointer to receive an output (may be nullptr)
    /// @param outMinValue pointer to receive an output (may be nullptr)
    /// @param outMaxId pointer to receive an output (may be nullptr)
    /// @param outMaxValue pointer to receive an output (may be nullptr)
    /// @returns true if objects were found (IDs/values are available)
    bool timeSeriesMinMax(obx_id* outMinId, int64_t* outMinValue, obx_id* outMaxId, int64_t* outMaxValue) {
        obx_err err = obx_box_ts_min_max(cBox_, outMinId, outMinValue, outMaxId, outMaxValue);
        if (err == OBX_SUCCESS) return true;
        if (err == OBX_NOT_FOUND) return false;
        throwLastError();
    }

    /// Time series: get the limits (min/max time values) over objects within the given time range
    /// @returns true if objects were found in the given range (IDs/values are available)
    bool timeSeriesMinMax(int64_t rangeBegin, int64_t rangeEnd, obx_id* outMinId, int64_t* outMinValue,
                          obx_id* outMaxId, int64_t* outMaxValue) {
        obx_err err =
            obx_box_ts_min_max_range(cBox_, rangeBegin, rangeEnd, outMinId, outMinValue, outMaxId, outMaxValue);
        if (err == OBX_SUCCESS) return true;
        if (err == OBX_NOT_FOUND) return false;
        throwLastError();
    }

private:
#ifndef OBX_DISABLE_FLATBUFFERS

    template <typename Vector>
    size_t putMany(Vector& objects, std::vector<obx_id>* outIds, OBXPutMode mode) {
        if (outIds) {
            outIds->clear();
            outIds->reserve(objects.size());
        }

        // Don't start a TX in case there's no data.
        // Note: Don't move this above clearing outIds vector - our contract says that we clear outIds before starting
        // execution so we must do it even if no objects were passed.
        if (objects.empty()) return 0;

        size_t count = 0;
        CursorTx cursor(TxMode::WRITE, store_, EntityBinding::entityId());
        for (auto& object : objects) {
            obx_id id = cursorPut(cursor, object, mode);  // type-based overloads here
            if (outIds) outIds->push_back(id);  // always include in outIds even if the item wasn't present (id == 0)
            if (id) count++;
        }
        cursor.commitAndClose();
        fbbCleanAfterUse();  // NOTE might not get called in case of an exception
        return count;
    }

    obx_id cursorPut(CursorTx& cursor, const EntityT& object, OBXPutMode mode) {
        EntityBinding::toFlatBuffer(fbb, object);
        obx_id id = obx_cursor_put_object4(cursor.cPtr(), fbb.GetBufferPointer(), fbb.GetSize(), mode);
        if (id == 0) throwLastError();
        return id;
    }

    obx_id cursorPut(CursorTx& cursor, EntityT& object, OBXPutMode mode) {
        obx_id id = cursorPut(cursor, const_cast<const EntityT&>(object), mode);
        EntityBinding::setObjectId(object, id);
        return id;
    }

    obx_id cursorPut(CursorTx& cursor, const std::unique_ptr<EntityT>& object, OBXPutMode mode) {
        return object ? cursorPut(cursor, *object, mode) : 0;
    }

#ifdef __cpp_lib_optional
    obx_id cursorPut(CursorTx& cursor, std::optional<EntityT>& object, OBXPutMode mode) {
        return object.has_value() ? cursorPut(cursor, *object, mode) : 0;
    }
#endif

#endif  // OBX_DISABLE_FLATBUFFERS

    template <typename Item>
    std::vector<Item> getMany(const std::vector<obx_id>& ids) {
        std::vector<Item> result;
        result.resize(ids.size());  // prepare empty/nullptr pointers in the output

        CursorTx cursor(TxMode::READ, store_, EntityBinding::entityId());
        const void* data;
        size_t size;

        for (size_t i = 0; i < ids.size(); i++) {
            obx_err err = obx_cursor_get(cursor.cPtr(), ids[i], &data, &size);
            if (err == OBX_NOT_FOUND) continue;  // leave empty at result[i] in this case
            checkErrOrThrow(err);
            readFromFb(result[i], data, size);
        }

        return result;
    }

    void readFromFb(std::unique_ptr<EntityT>& object, const void* data, size_t size) {
        object = EntityBinding::newFromFlatBuffer(data, size);
    }

#ifdef __cpp_lib_optional
    void readFromFb(std::optional<EntityT>& object, const void* data, size_t size) {
        object = EntityT();
        assert(object.has_value());
        EntityBinding::fromFlatBuffer(data, size, *object);
    }
#endif
};

/// AsyncBox provides asynchronous ("happening on the background") database manipulation.
template <typename EntityT>
class AsyncBox {
    using EntityBinding = typename EntityT::_OBX_MetaInfo;

    friend Box<EntityT>;

    const bool created_;  // whether this is a custom async box (true) or a shared instance (false)
    OBX_async* cAsync_;
    Store& store_;

    /// Creates a shared AsyncBox instance.
    explicit AsyncBox(Box<EntityT>& box) : AsyncBox(box.store_, false, obx_async(box.cPtr())) {}

    /// Creates a shared AsyncBox instance.
    AsyncBox(Store& store, bool owned, OBX_async* ptr) : store_(store), created_(owned), cAsync_(ptr) {
        checkPtrOrThrow(cAsync_, "can't create async box");
    }

public:
    /// Create a custom AsyncBox instance. Prefer using Box::async() for standard tasks, it gives you a shared instance.
    AsyncBox(Store& store, uint64_t enqueueTimeoutMillis)
        : AsyncBox(store, true, obx_async_create(store.box<EntityT>().cPtr(), enqueueTimeoutMillis)) {}

    /// Move constructor
    AsyncBox(AsyncBox&& source) noexcept : store_(source.store_), cAsync_(source.cAsync_), created_(source.created_) {
        source.cAsync_ = nullptr;
    }

    /// Can't be copied, single owner of C resources is required (to avoid double-free during destruction)
    AsyncBox(const AsyncBox&) = delete;

    virtual ~AsyncBox() {
        if (created_ && cAsync_) obx_async_close(cAsync_);
    }

    OBX_async* cPtr() const {
        OBJECTBOX_VERIFY_STATE(cAsync_);
        return cAsync_;
    }

#ifndef OBX_DISABLE_FLATBUFFERS

    /// Reserve an ID, which is returned immediately for future reference, and insert asynchronously.
    /// Note: of course, it can NOT be guaranteed that the entity will actually be inserted successfully in the DB.
    /// @param object will be updated with the reserved ID.
    /// @return the reserved ID which will be used for the object if the asynchronous insert succeeds.
    obx_id put(EntityT& object, OBXPutMode mode = OBXPutMode_PUT) {
        obx_id id = put(const_cast<const EntityT&>(object));
        EntityBinding::setObjectId(object, id);
        return id;
    }

    /// Reserve an ID, which is returned immediately for future reference and put asynchronously.
    /// Note: of course, it can NOT be guaranteed that the entity will actually be put successfully in the DB.
    /// @param mode - use INSERT or PUT; in case you need to use UPDATE, use the C-API directly for now
    /// @return the reserved ID which will be used for the object if the asynchronous insert succeeds.
    obx_id put(const EntityT& object, OBXPutMode mode = OBXPutMode_PUT) {
        EntityBinding::toFlatBuffer(fbb, object);
        obx_id id = obx_async_put_object4(cPtr(), fbb.GetBufferPointer(), fbb.GetSize(), mode);
        fbbCleanAfterUse();
        if (id == 0) throwLastError();
        return id;
    }

#endif  // OBX_DISABLE_FLATBUFFERS

    /// Asynchronously remove the object with the given id.
    void remove(obx_id id) { checkErrOrThrow(obx_async_remove(cPtr(), id)); }

    /// Await for all (including future) async submissions to be completed (the async queue becomes idle for a moment).
    /// Currently this is not limited to the single entity this AsyncBox is working on but all entities in the store.
    /// @returns true if all submissions were completed or async processing was not started; false if shutting down
    /// @returns false if shutting down or an error occurred
    bool awaitCompletion() { return obx_store_await_async_completion(store_.cPtr()); }

    /// Await for previously submitted async operations to be completed (the async queue does not have to become idle).
    /// Currently this is not limited to the single entity this AsyncBox is working on but all entities in the store.
    /// @returns true if all submissions were completed or async processing was not started
    /// @returns false if shutting down or an error occurred
    bool awaitSubmitted() { return obx_store_await_async_submitted(store_.cPtr()); }
};

inline Store::~Store() {
    {
        // Clean up SyncClient by explicitly closing it, even if it isn't the only shared_ptr to the instance.
        // This prevents invalid use of store after it's been closed.
        std::shared_ptr<Closable> syncClient;
        {
            std::lock_guard<std::mutex> lock(syncClientMutex_);
            syncClient = std::move(syncClient_);
            syncClient_ = nullptr;  // to make the current state obvious
        }

        if (syncClient && !syncClient->isClosed()) {
#ifndef NDEBUG  // todo we probably want our LOG macros here too
            long useCount = syncClient.use_count();
            if (useCount > 1) {  // print external refs only thus "- 1"
                printf("SyncClient still active with %ld references when store got closed\n", (useCount - 1));
            }
#endif  // NDEBUG
            syncClient->close();
        }
    }

    if (owned_) obx_store_close(cStore_);
}

/**@}*/  // end of doxygen group
}  // namespace obx