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

#include "objectbox-sync.h"
#include "objectbox.hpp"

static_assert(OBX_VERSION_MAJOR == 0 && OBX_VERSION_MINOR == 16 && OBX_VERSION_PATCH == 0,
              "Versions of objectbox.h and objectbox-sync.hpp files do not match, please update");

static_assert(sizeof(obx_id) == sizeof(OBX_id_array::ids[0]),
              "Can't directly link OBX_id_array.ids to std::vector<obx_id>::data()");

namespace obx {

class SyncCredentials {
    friend SyncClient;
    friend SyncServer;
    OBXSyncCredentialsType type_;
    std::vector<uint8_t> data_;

public:
    SyncCredentials(OBXSyncCredentialsType type, std::vector<uint8_t>&& data) : type_(type), data_(std::move(data)) {}

    SyncCredentials(OBXSyncCredentialsType type, const std::string& data) : type_(type), data_(data.size()) {
        static_assert(sizeof(data_[0]) == sizeof(data[0]), "Can't directly copy std::string to std::vector<uint8_t>");
        if (!data.empty()) memcpy(data_.data(), data.data(), data.size() * sizeof(data[0]));
    }

    static SyncCredentials none() {
        return SyncCredentials(OBXSyncCredentialsType::OBXSyncCredentialsType_NONE, std::vector<uint8_t>{});
    }

    static SyncCredentials sharedSecret(std::vector<uint8_t>&& data) {
        return SyncCredentials(OBXSyncCredentialsType::OBXSyncCredentialsType_SHARED_SECRET, std::move(data));
    }

    static SyncCredentials sharedSecret(const std::string& str) {
        return SyncCredentials(OBXSyncCredentialsType::OBXSyncCredentialsType_SHARED_SECRET, str);
    }

    static SyncCredentials googleAuth(const std::string& str) {
        return SyncCredentials(OBXSyncCredentialsType::OBXSyncCredentialsType_GOOGLE_AUTH, str);
    }
};

/// Listens to login events on a sync client.
class SyncClientLoginListener {
public:
    /// Called on a successful login.
    /// At this point the connection to the sync destination was established and
    /// entered an operational state, in which data can be sent both ways.
    virtual void loggedIn() noexcept = 0;

    /// Called on a login failure with a `result` code specifying the issue.
    virtual void loginFailed(OBXSyncCode) noexcept = 0;
};

/// Listens to sync client connection events.
class SyncClientConnectionListener {
public:
    /// Called when connection is established (on first connect or after a reconnection).
    virtual void connected() noexcept = 0;

    /// Called when the client is disconnected from the sync server, e.g. due to a network error.
    /// Depending on the configuration, the sync client typically tries to reconnect automatically, triggering
    /// `connected()` when successful.
    virtual void disconnected() noexcept = 0;
};

/// Listens to sync complete event on a sync client.
class SyncClientCompletionListener {
public:
    /// Called each time a sync completes, in the sense that the client has caught up with the current server state.
    /// Or in other words, when the client is "up-to-date".
    virtual void updatesCompleted() noexcept = 0;
};

/// Listens to sync time information events on a sync client.
class SyncClientTimeListener {
public:
    using TimePoint = std::chrono::time_point<std::chrono::system_clock, std::chrono::nanoseconds>;

    /// Called when a server time information is received on the client.
    /// @param time - current server timestamp since Unix epoch
    virtual void serverTime(TimePoint time) noexcept = 0;
};

/// A collection of changes made to one entity type during a sync transaction. Delivered via SyncClientChangeListener.
/// IDs of changed objects are available via `puts` and those of removed objects via `removals`.
struct SyncChange {
    obx_schema_id entityId;
    std::vector<obx_id> puts;
    std::vector<obx_id> removals;
};

/// Notifies of fine granular changes on the object level happening during sync.
/// @note this may affect performance. Use SyncClientCompletionListener for the general synchronization-finished check.
class SyncChangeListener {
public:
    /// Called each time when data `changes` from sync were applied locally.
    virtual void changed(const std::vector<SyncChange>& changes) noexcept = 0;

private:
    friend SyncClient;
    friend SyncServer;

    void changed(const OBX_sync_change_array* cChanges) noexcept {
        std::vector<SyncChange> changes(cChanges->count);

        for (size_t i = 0; i < cChanges->count; i++) {
            const OBX_sync_change& cChange = cChanges->list[i];
            SyncChange& change = changes[i];
            change.entityId = cChange.entity_id;
            copyIdVector(cChange.puts, change.puts);
            copyIdVector(cChange.removals, change.removals);
        }

        changed(changes);
    }

    void copyIdVector(const OBX_id_array* in, std::vector<obx_id>& out) {
        static_assert(sizeof(in->ids[0]) == sizeof(out[0]), "Can't directly copy OBX_id_array to std::vector<obx_id>");
        if (!in) {
            out.clear();
        } else {
            out.resize(in->count);
            memcpy(out.data(), in->ids, sizeof(out[0]) * out.size());
        }
    }
};

/// Listens to all possible sync events. See each base abstract class for detailed information.
class SyncClientListener : public SyncClientLoginListener,
                           public SyncClientCompletionListener,
                           public SyncClientConnectionListener,
                           public SyncChangeListener,
                           public SyncClientTimeListener {};

class SyncObjectsMessageListener {
public:
    // TODO do we want to transform to a more c++ friendly representation, like in other listeners?
    virtual void received(const OBX_sync_msg_objects* cObjects) noexcept = 0;
};

/// Sync client is used to provide ObjectBox Sync client capabilities to your application.
class SyncClient : public Closable {
    Store& store_;
    std::atomic<OBX_sync*> cSync_{nullptr};

    /// Groups all listeners and the mutex that protects access to them. We could have a separate mutex for each
    /// listener but that's probably an overkill.
    struct {
        std::mutex mutex;
        std::shared_ptr<SyncClientLoginListener> login;
        std::shared_ptr<SyncClientCompletionListener> complete;
        std::shared_ptr<SyncClientConnectionListener> connect;
        std::shared_ptr<SyncChangeListener> change;
        std::shared_ptr<SyncClientTimeListener> time;
        std::shared_ptr<SyncClientListener> combined;
    } listeners_;

    using Guard = std::lock_guard<std::mutex>;

public:
    /// Creates a sync client associated with the given store and options.
    /// This does not initiate any connection attempts yet: call start() to do so.
    explicit SyncClient(Store& store, const std::string& serverUri, const SyncCredentials& creds) : store_(store) {
        cSync_ = checkPtrOrThrow(obx_sync(store.cPtr(), serverUri.c_str()), "can't initialize sync client");
        try {
            setCredentials(creds);
        } catch (...) {
            closeNonVirtual();  // free native resources before throwing
            throw;
        }
    }

    /// Creates a sync client associated with the given store and options.
    /// This does not initiate any connection attempts yet: call start() to do so.
    /// @param cSync an initialized sync client. You must NOT call obx_sync_close() yourself anymore.
    explicit SyncClient(Store& store, OBX_sync* cSync) : store_(store), cSync_(cSync) {
        OBJECTBOX_VERIFY_STATE(obx_has_feature(OBXFeature_Sync));
        OBJECTBOX_VERIFY_ARGUMENT(cSync);
    }

    /// Can't be moved due to the atomic cSync_ - use shared_ptr instead of SyncClient instances directly.
    SyncClient(SyncClient&& source) = delete;

    /// Can't be copied, single owner of C resources is required (to avoid double-free during destruction)
    SyncClient(const SyncClient&) = delete;

    virtual ~SyncClient() {
        try {
            closeNonVirtual();
        } catch (...) {
        }
    }

    /// Closes and cleans up all resources used by this sync client.
    /// It can no longer be used afterwards, make a new sync client instead.
    /// Does nothing if this sync client has already been closed.
    void close() override { closeNonVirtual(); }

    /// Returns if this sync client is closed and can no longer be used.
    bool isClosed() override { return cSync_ == nullptr; }

    /// Gets the current sync client state.
    OBXSyncState state() const { return obx_sync_state(cPtr()); }

    /// Gets the protocol version this client uses.
    static uint32_t protocolVersion() { return obx_sync_protocol_version(); }

    /// Returns the protocol version of the server after a connection was established (or attempted), zero otherwise.
    uint32_t serverProtocolVersion() const { return obx_sync_protocol_version_server(cPtr()); }

    /// Configure authentication credentials.
    /// The accepted OBXSyncCredentials type depends on your sync-server configuration.
    void setCredentials(const SyncCredentials& creds) {
        checkErrOrThrow(obx_sync_credentials(cPtr(), creds.type_, creds.data_.empty() ? nullptr : creds.data_.data(),
                                             creds.data_.size()));
    }

    /// Sets the interval in which the client sends "heartbeat" messages to the server, keeping the connection alive.
    /// To detect disconnects early on the client side, you can also use heartbeats with a smaller interval.
    /// Use with caution, setting a low value (i.e. sending heartbeat very often) may cause an excessive network usage
    /// as well as high server load (when there are many connected clients).
    /// @param interval default value is 25 minutes (1 500 000 milliseconds), which is also the allowed maximum.
    /// @throws if value is not in the allowed range, e.g. larger than the maximum (1 500 000).
    void setHeartbeatInterval(std::chrono::milliseconds interval) {
        checkErrOrThrow(obx_sync_heartbeat_interval(cPtr(), interval.count()));
    }

    /// Triggers the heartbeat sending immediately.
    void sendHeartbeat() { checkErrOrThrow(obx_sync_send_heartbeat(cPtr())); }

    /// Configures how sync updates are received from the server.
    /// If automatic sync updates are turned off, they will need to be requested manually.
    void setRequestUpdatesMode(OBXRequestUpdatesMode mode) {
        checkErrOrThrow(obx_sync_request_updates_mode(cPtr(), mode));
    }

    /// Configures the maximum number of outgoing TX messages that can be sent without an ACK from the server.
    /// @throws if value is not in the valid range 1-20
    void maxMessagesInFlight(int value) { checkErrOrThrow(obx_sync_max_messages_in_flight(cPtr(), value)); }

    /// Once the sync client is configured, you can "start" it to initiate synchronization.
    /// This method triggers communication in the background and will return immediately.
    /// If the synchronization destination is reachable, this background thread will connect to the server,
    /// log in (authenticate) and, depending on "update request mode", start syncing data.
    /// If the device, network or server is currently offline, connection attempts will be retried later using
    /// increasing backoff intervals.
    /// If you haven't set the credentials in the options during construction, call setCredentials() before start().
    void start() { checkErrOrThrow(obx_sync_start(cPtr())); }

    /// Stops this sync client. Does nothing if it is already stopped.
    void stop() { checkErrOrThrow(obx_sync_stop(cPtr())); }

    /// Request updates since we last synchronized our database.
    /// @param subscribeForFuturePushes to keep sending us future updates as they come in.
    /// @see updatesCancel() to stop the updates
    bool requestUpdates(bool subscribeForFuturePushes) {
        return checkSuccessOrThrow(obx_sync_updates_request(cPtr(), subscribeForFuturePushes));
    }

    /// Cancel updates from the server so that it will stop sending updates.
    /// @see updatesRequest()
    bool cancelUpdates() { return checkSuccessOrThrow(obx_sync_updates_cancel(cPtr())); }

    /// Count the number of messages in the outgoing queue, i.e. those waiting to be sent to the server.
    /// Note: This calls uses a (read) transaction internally: 1) it's not just a "cheap" return of a single number.
    ///       While this will still be fast, avoid calling this function excessively.
    ///       2) the result follows transaction view semantics, thus it may not always match the actual value.
    /// @return the number of messages in the outgoing queue
    uint64_t outgoingMessageCount(uint64_t limit = 0) {
        uint64_t result;
        checkErrOrThrow(obx_sync_outgoing_message_count(cPtr(), limit, &result));
        return result;
    }

    // TODO remove c-style listeners to avoid confusion? Users would still be able use them directly through the C-API.

    /// @param listener set NULL to reset
    /// @param listenerArg is a pass-through argument passed to the listener
    void setConnectListener(OBX_sync_listener_connect* listener, void* listenerArg) {
        obx_sync_listener_connect(cPtr(), listener, listenerArg);
    }

    /// @param listener set NULL to reset
    /// @param listenerArg is a pass-through argument passed to the listener
    void setDisconnectListener(OBX_sync_listener_disconnect* listener, void* listenerArg) {
        obx_sync_listener_disconnect(cPtr(), listener, listenerArg);
    }

    /// @param listener set NULL to reset
    /// @param listenerArg is a pass-through argument passed to the listener
    void setLoginListener(OBX_sync_listener_login* listener, void* listenerArg) {
        obx_sync_listener_login(cPtr(), listener, listenerArg);
    }

    /// @param listener set NULL to reset
    /// @param listenerArg is a pass-through argument passed to the listener
    void setLoginFailureListener(OBX_sync_listener_login_failure* listener, void* listenerArg) {
        obx_sync_listener_login_failure(cPtr(), listener, listenerArg);
    }

    /// @param listener set NULL to reset
    /// @param listenerArg is a pass-through argument passed to the listener
    void setCompleteListener(OBX_sync_listener_complete* listener, void* listenerArg) {
        obx_sync_listener_complete(cPtr(), listener, listenerArg);
    }

    /// @param listener set NULL to reset
    /// @param listenerArg is a pass-through argument passed to the listener
    void setChangeListener(OBX_sync_listener_change* listener, void* listenerArg) {
        obx_sync_listener_change(cPtr(), listener, listenerArg);
    }

    void setLoginListener(std::shared_ptr<SyncClientLoginListener> listener) {
        Guard lock(listeners_.mutex);

        // if it was previosly set, unassign in the core before (potentially) destroying the object
        removeLoginListener();

        if (listener) {
            listeners_.login = std::move(listener);
            void* arg = listeners_.login.get();

            obx_sync_listener_login(
                cPtr(), [](void* arg) { static_cast<SyncClientLoginListener*>(arg)->loggedIn(); }, arg);
            obx_sync_listener_login_failure(
                cPtr(),
                [](void* arg, OBXSyncCode code) { static_cast<SyncClientLoginListener*>(arg)->loginFailed(code); },
                arg);
        }
    }

    void setCompletionListener(std::shared_ptr<SyncClientCompletionListener> listener) {
        Guard lock(listeners_.mutex);

        // if it was previously set, unassign in the core before (potentially) destroying the object
        removeCompletionListener();

        if (listener) {
            listeners_.complete = std::move(listener);
            obx_sync_listener_complete(
                cPtr(), [](void* arg) { static_cast<SyncClientCompletionListener*>(arg)->updatesCompleted(); },
                listeners_.complete.get());
        }
    }

    void setConnectionListener(std::shared_ptr<SyncClientConnectionListener> listener) {
        Guard lock(listeners_.mutex);

        // if it was previously set, unassign in the core before (potentially) destroying the object
        removeConnectionListener();

        if (listener) {
            listeners_.connect = std::move(listener);
            void* arg = listeners_.connect.get();

            obx_sync_listener_connect(
                cPtr(), [](void* arg) { static_cast<SyncClientConnectionListener*>(arg)->connected(); }, arg);
            obx_sync_listener_disconnect(
                cPtr(), [](void* arg) { static_cast<SyncClientConnectionListener*>(arg)->disconnected(); }, arg);
        }
    }

    void setTimeListener(std::shared_ptr<SyncClientTimeListener> listener) {
        Guard lock(listeners_.mutex);

        // if it was previously set, unassign in the core before (potentially) destroying the object
        removeTimeListener();

        if (listener) {
            listeners_.time = std::move(listener);
            obx_sync_listener_server_time(
                cPtr(),
                [](void* arg, int64_t timestampNs) {
                    static_cast<SyncClientTimeListener*>(arg)->serverTime(
                        SyncClientTimeListener::TimePoint(std::chrono::nanoseconds(timestampNs)));
                },
                listeners_.time.get());
        }
    }

    void setChangeListener(std::shared_ptr<SyncChangeListener> listener) {
        Guard lock(listeners_.mutex);

        // if it was previously set, unassign in the core before (potentially) destroying the object
        removeChangeListener();

        if (listener) {
            listeners_.change = std::move(listener);
            obx_sync_listener_change(
                cPtr(),
                [](void* arg, const OBX_sync_change_array* cChanges) {
                    static_cast<SyncChangeListener*>(arg)->changed(cChanges);
                },
                listeners_.change.get());
        }
    }

    void setListener(std::shared_ptr<SyncClientListener> listener) {
        Guard lock(listeners_.mutex);

        // if it was previously set, unassign in the core before (potentially) destroying the object
        bool forceRemove = listeners_.combined.get() != nullptr;
        removeLoginListener(forceRemove);
        removeCompletionListener(forceRemove);
        removeConnectionListener(forceRemove);
        removeTimeListener(forceRemove);
        removeChangeListener(forceRemove);
        listeners_.combined.reset();

        if (listener) {
            listeners_.combined = std::move(listener);
            void* arg = listeners_.combined.get();

            // Note: we need to use a templated forward* method so that the override for the right class is called.
            obx_sync_listener_login(
                cPtr(), [](void* arg) { static_cast<SyncClientListener*>(arg)->loggedIn(); }, arg);
            obx_sync_listener_login_failure(
                cPtr(), [](void* arg, OBXSyncCode code) { static_cast<SyncClientListener*>(arg)->loginFailed(code); },
                arg);
            obx_sync_listener_complete(
                cPtr(), [](void* arg) { static_cast<SyncClientListener*>(arg)->updatesCompleted(); }, arg);
            obx_sync_listener_connect(
                cPtr(), [](void* arg) { static_cast<SyncClientListener*>(arg)->connected(); }, arg);
            obx_sync_listener_disconnect(
                cPtr(), [](void* arg) { static_cast<SyncClientListener*>(arg)->disconnected(); }, arg);
            obx_sync_listener_server_time(
                cPtr(),
                [](void* arg, int64_t timestampNs) {
                    static_cast<SyncClientListener*>(arg)->serverTime(
                        SyncClientTimeListener::TimePoint(std::chrono::nanoseconds(timestampNs)));
                },
                arg);
            obx_sync_listener_change(
                cPtr(),
                [](void* arg, const OBX_sync_change_array* cChanges) {
                    static_cast<SyncClientListener*>(arg)->changed(cChanges);
                },
                arg);
        }
    }

protected:
    OBX_sync* cPtr() const {
        OBX_sync* ptr = cSync_;
        if (ptr == nullptr) throw std::runtime_error("Sync client was already closed");
        return ptr;
    }

    /// Close, but non-virtual to allow calls from constructor/destructor.
    void closeNonVirtual() {
        OBX_sync* ptr = cSync_.exchange(nullptr);
        if (ptr) {
            {
                std::lock_guard<std::mutex> lock(store_.syncClientMutex_);
                store_.syncClient_.reset();
            }
            checkErrOrThrow(obx_sync_close(ptr));
        }
    }

    void removeLoginListener(bool evenIfEmpty = false) {
        std::shared_ptr<SyncClientLoginListener> listener = std::move(listeners_.login);
        if (listener || evenIfEmpty) {
            obx_sync_listener_login(cPtr(), nullptr, nullptr);
            obx_sync_listener_login_failure(cPtr(), nullptr, nullptr);
        }
    }

    void removeCompletionListener(bool evenIfEmpty = false) {
        std::shared_ptr<SyncClientCompletionListener> listener = std::move(listeners_.complete);
        if (listener || evenIfEmpty) {
            obx_sync_listener_complete(cPtr(), nullptr, nullptr);
            listener.reset();
        }
    }

    void removeConnectionListener(bool evenIfEmpty = false) {
        std::shared_ptr<SyncClientConnectionListener> listener = std::move(listeners_.connect);
        if (listener || evenIfEmpty) {
            obx_sync_listener_connect(cPtr(), nullptr, nullptr);
            obx_sync_listener_disconnect(cPtr(), nullptr, nullptr);
            listener.reset();
        }
    }

    void removeTimeListener(bool evenIfEmpty = false) {
        std::shared_ptr<SyncClientTimeListener> listener = std::move(listeners_.time);
        if (listener || evenIfEmpty) {
            obx_sync_listener_server_time(cPtr(), nullptr, nullptr);
            listener.reset();
        }
    }

    void removeChangeListener(bool evenIfEmpty = false) {
        std::shared_ptr<SyncChangeListener> listener = std::move(listeners_.change);
        if (listener || evenIfEmpty) {
            obx_sync_listener_change(cPtr(), nullptr, nullptr);
            listener.reset();
        }
    }
};

/// <a href="https://objectbox.io/sync/">ObjectBox Sync</a> makes data available on other devices.
/// Start building a sync client using client() and connect to a remote server.
class Sync {
public:
    static bool isAvailable() { return obx_has_feature(OBXFeature_Sync); }

    /// Creates a sync client associated with the given store and configures it with the given options.
    /// This does not initiate any connection attempts yet: call SyncClient::start() to do so.
    /// Before start(), you can still configure some aspects of the sync client, e.g. its "request update" mode.
    /// @note While you may not interact with SyncClient directly after start(), you need to hold on to the object.
    ///       Make sure the SyncClient is not destroyed and thus synchronization can keep running in the background.
    static std::shared_ptr<SyncClient> client(Store& store, const std::string& serverUri,
                                              const SyncCredentials& creds) {
        std::lock_guard<std::mutex> lock(store.syncClientMutex_);
        if (store.syncClient_) throw std::runtime_error("Only one sync client can be active for a store");
        store.syncClient_.reset(new SyncClient(store, serverUri, creds));
        return std::static_pointer_cast<SyncClient>(store.syncClient_);
    }

    /// Adopts an existing OBX_sync* sync client, taking ownership of the pointer.
    /// @param cSync an initialized sync client. You must NOT call obx_sync_close() yourself anymore.
    static std::shared_ptr<SyncClient> client(Store& store, OBX_sync* cSync) {
        std::lock_guard<std::mutex> lock(store.syncClientMutex_);
        if (store.syncClient_) throw std::runtime_error("Only one sync client can be active for a store");
        store.syncClient_.reset(new SyncClient(store, cSync));
        return std::static_pointer_cast<SyncClient>(store.syncClient_);
    }
};

inline std::shared_ptr<SyncClient> Store::syncClient() {
    std::lock_guard<std::mutex> lock(syncClientMutex_);
    return std::static_pointer_cast<SyncClient>(syncClient_);
}

/// The ObjectBox Sync Server to run within your application (embedded server).
/// Note that you need a special sync edition, which includes the server components. Check https://objectbox.io/sync/.
class SyncServer : public Closable {
    OBX_sync_server* cPtr_;
    std::unique_ptr<Store> store_;

    /// Groups all listeners and the mutex that protects access to them. We could have a separate mutex for each
    /// listener but that's probably an overkill.
    struct {
        std::mutex mutex;
        std::shared_ptr<SyncChangeListener> change;
        std::shared_ptr<SyncObjectsMessageListener> object;
    } listeners_;

    using Guard = std::lock_guard<std::mutex>;

public:
    static bool isAvailable() { return obx_has_feature(OBXFeature_SyncServer); }

    /// Prepares an ObjectBox Sync Server to run within your application (embedded server) at the given URI.
    /// This call opens a store with the given options (as Store() does). Get it via store().
    /// The server's store is tied to the server itself and is closed when the server is closed.
    /// Before actually starting the server via start(), you can configure:
    /// - accepted credentials via setCredentials() (always required)
    /// - SSL certificate info via setCertificatePath() (required if you use wss)
    /// \note The model given via store_options is also used to verify the compatibility of the models presented by
    /// clients.
    ///       E.g. a client with an incompatible model will be rejected during login.
    /// @param storeOptions Options for the server's store. Will be "consumed"; do not use the Options object again.
    /// @param uri The URI (following the pattern protocol:://IP:port) the server should listen on.
    ///        Supported \b protocols are "ws" (WebSockets) and "wss" (secure WebSockets).
    ///        To use the latter ("wss"), you must also call obx_sync_server_certificate_path().
    ///        To bind to all available \b interfaces, including those that are available from the "outside", use
    ///        0.0.0.0 as the IP. On the other hand, "127.0.0.1" is typically (may be OS dependent) only available on
    ///        the same device. If you do not require a fixed \b port, use 0 (zero) as a port to tell the server to pick
    ///        an arbitrary port that is available. The port can be queried via obx_sync_server_port() once the server
    ///        was started. \b Examples: "ws://0.0.0.0:9999" could be used during development (no certificate config
    ///        needed), while in a production system, you may want to use wss and a specific IP for security reasons.
    explicit SyncServer(Options& storeOptions, const std::string& uri) {
        cPtr_ = checkPtrOrThrow(obx_sync_server(storeOptions.release(), uri.c_str()), "Could not create SyncServer");
        try {
            OBX_store* cStore = checkPtrOrThrow(obx_sync_server_store(cPtr_), "Can't get SyncServer's store");
            store_.reset(new Store(cStore, false));
        } catch (...) {
            close();
            throw;
        }
    }

    /// Rvalue variant of SyncServer(Options& storeOptions, const std::string& uri) that works equivalently.
    explicit SyncServer(Options&& storeOptions, const std::string& uri) : SyncServer((Options&) storeOptions, uri) {}

    SyncServer(SyncServer&& source) noexcept : cPtr_(source.cPtr_) {
        source.cPtr_ = nullptr;
        Guard lock(source.listeners_.mutex);
        std::swap(listeners_.change, source.listeners_.change);
    }

    /// Can't be copied, single owner of C resources is required (to avoid double-free during destruction)
    SyncServer(const SyncServer&) = delete;

    ~SyncServer() override {
        try {
            close();
        } catch (...) {
        }
    }

    /// The store that is associated with this server.
    Store& store() {
        OBJECTBOX_VERIFY_STATE(store_);
        return *store_;
    }

    /// Closes and cleans up all resources used by this sync server. Does nothing if already closed.
    /// It can no longer be used afterwards, make a new sync server instead.
    void close() final {
        OBX_sync_server* ptr = cPtr_;
        cPtr_ = nullptr;
        store_.reset();
        if (ptr) {
            checkErrOrThrow(obx_sync_server_close(ptr));
        }
    }

    /// Returns if this sync server is closed and can no longer be used.
    bool isClosed() override { return cPtr_ == nullptr; }

    /// Sets SSL certificate for the server to use. Use before start().
    void setCertificatePath(const std::string& path) {
        checkErrOrThrow(obx_sync_server_certificate_path(cPtr(), path.c_str()));
    }

    /// Sets credentials for the server to accept. Use before start().
    /// @param data may be NULL in combination with OBXSyncCredentialsType_NONE
    void setCredentials(const SyncCredentials& creds) {
        checkErrOrThrow(obx_sync_server_credentials(
            cPtr(), creds.type_, creds.data_.empty() ? nullptr : creds.data_.data(), creds.data_.size()));
    }

    /// Once the sync server is configured, you can "start" it to start accepting client connections.
    /// This method triggers communication in the background and will return immediately.
    void start() { checkErrOrThrow(obx_sync_server_start(cPtr())); }

    /// Stops this sync server. Does nothing if it is already stopped.
    void stop() { checkErrOrThrow(obx_sync_server_stop(cPtr())); }

    /// Returns if this sync server is running
    bool isRunning() { return obx_sync_server_running(cPtr()); }

    /// Returns a URL this server is listening on, including the bound port (see port().
    std::string url() { return checkPtrOrThrow(obx_sync_server_url(cPtr()), "Can't get SyncServer bound URL"); }

    /// Returns a port this server listens on. This is especially useful if the bindUri given to the constructor
    /// specified "0" port (i.e. automatic assignment).
    uint16_t port() {
        uint16_t result = obx_sync_server_port(cPtr());
        if (!result) throwLastError();
        return result;
    }

    /// Returns the number of clients connected to this server.
    uint64_t connections() { return obx_sync_server_connections(cPtr()); }

    /// Get server runtime statistics.
    std::string statsString(bool includeZeroValues = true) {
        return checkPtrOrThrow(obx_sync_server_stats_string(cPtr(), includeZeroValues),
                               "Can't get SyncServer stats string");
    }

    void setChangeListener(std::shared_ptr<SyncChangeListener> listener) {
        Guard lock(listeners_.mutex);

        // Keep the previous listener (if any) alive so the core may still call it before we finally switch.
        // TODO, this is implemented differently (more efficiently?) than client listeners, consider changing there too?
        listeners_.change.swap(listener);

        if (listeners_.change) {  // switch if a new listener was given
            obx_sync_server_listener_change(
                cPtr(),
                [](void* arg, const OBX_sync_change_array* cChanges) {
                    static_cast<SyncChangeListener*>(arg)->changed(cChanges);
                },
                listeners_.change.get());
        } else if (listener) {  // unset the previous listener, if set
            obx_sync_server_listener_change(cPtr(), nullptr, nullptr);
        }
    }

    void setObjectsMessageListener(std::shared_ptr<SyncObjectsMessageListener> listener) {
        Guard lock(listeners_.mutex);

        // Keep the previous listener (if any) alive so the core may still call it before we finally switch.
        listeners_.object.swap(listener);

        if (listeners_.object) {  // switch if a new listener was given
            obx_sync_server_listener_msg_objects(
                cPtr(),
                [](void* arg, const OBX_sync_msg_objects* cObjects) {
                    static_cast<SyncObjectsMessageListener*>(arg)->received(cObjects);
                },
                listeners_.object.get());
        } else if (listener) {  // unset the previous listener, if set
            obx_sync_server_listener_msg_objects(cPtr(), nullptr, nullptr);
        }
    }

protected:
    OBX_sync_server* cPtr() const {
        OBX_sync_server* ptr = cPtr_;
        if (ptr == nullptr) throw std::runtime_error("Sync server was already closed");
        return ptr;
    }
};

/**@}*/  // end of doxygen group
}  // namespace obx