// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_db_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BillDbModelCWProxy {
  BillDbModel id(int id);

  BillDbModel cron(String? cron);

  BillDbModel startAt(DateTime? startAt);

  BillDbModel finishAt(DateTime? finishAt);

  BillDbModel title(String? title);

  BillDbModel categoryId(int categoryId);

  BillDbModel lastTransactionId(int? lastTransactionId);

  BillDbModel autoAddTranaction(bool autoAddTranaction);

  BillDbModel totalExpense(double? totalExpense);

  BillDbModel createdAt(DateTime createdAt);

  BillDbModel updatedAt(DateTime? updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BillDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BillDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  BillDbModel call({
    int? id,
    String? cron,
    DateTime? startAt,
    DateTime? finishAt,
    String? title,
    int? categoryId,
    int? lastTransactionId,
    bool? autoAddTranaction,
    double? totalExpense,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBillDbModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBillDbModel.copyWith.fieldName(...)`
class _$BillDbModelCWProxyImpl implements _$BillDbModelCWProxy {
  const _$BillDbModelCWProxyImpl(this._value);

  final BillDbModel _value;

  @override
  BillDbModel id(int id) => this(id: id);

  @override
  BillDbModel cron(String? cron) => this(cron: cron);

  @override
  BillDbModel startAt(DateTime? startAt) => this(startAt: startAt);

  @override
  BillDbModel finishAt(DateTime? finishAt) => this(finishAt: finishAt);

  @override
  BillDbModel title(String? title) => this(title: title);

  @override
  BillDbModel categoryId(int categoryId) => this(categoryId: categoryId);

  @override
  BillDbModel lastTransactionId(int? lastTransactionId) =>
      this(lastTransactionId: lastTransactionId);

  @override
  BillDbModel autoAddTranaction(bool autoAddTranaction) =>
      this(autoAddTranaction: autoAddTranaction);

  @override
  BillDbModel totalExpense(double? totalExpense) =>
      this(totalExpense: totalExpense);

  @override
  BillDbModel createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  BillDbModel updatedAt(DateTime? updatedAt) => this(updatedAt: updatedAt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BillDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BillDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  BillDbModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? cron = const $CopyWithPlaceholder(),
    Object? startAt = const $CopyWithPlaceholder(),
    Object? finishAt = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? categoryId = const $CopyWithPlaceholder(),
    Object? lastTransactionId = const $CopyWithPlaceholder(),
    Object? autoAddTranaction = const $CopyWithPlaceholder(),
    Object? totalExpense = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return BillDbModel(
      id: id == const $CopyWithPlaceholder() || id == null
          // ignore: unnecessary_non_null_assertion
          ? _value.id!
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      cron: cron == const $CopyWithPlaceholder()
          ? _value.cron
          // ignore: cast_nullable_to_non_nullable
          : cron as String?,
      startAt: startAt == const $CopyWithPlaceholder()
          ? _value.startAt
          // ignore: cast_nullable_to_non_nullable
          : startAt as DateTime?,
      finishAt: finishAt == const $CopyWithPlaceholder()
          ? _value.finishAt
          // ignore: cast_nullable_to_non_nullable
          : finishAt as DateTime?,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String?,
      categoryId:
          categoryId == const $CopyWithPlaceholder() || categoryId == null
              // ignore: unnecessary_non_null_assertion
              ? _value.categoryId!
              // ignore: cast_nullable_to_non_nullable
              : categoryId as int,
      lastTransactionId: lastTransactionId == const $CopyWithPlaceholder()
          ? _value.lastTransactionId
          // ignore: cast_nullable_to_non_nullable
          : lastTransactionId as int?,
      autoAddTranaction: autoAddTranaction == const $CopyWithPlaceholder() ||
              autoAddTranaction == null
          // ignore: unnecessary_non_null_assertion
          ? _value.autoAddTranaction!
          // ignore: cast_nullable_to_non_nullable
          : autoAddTranaction as bool,
      totalExpense: totalExpense == const $CopyWithPlaceholder()
          ? _value.totalExpense
          // ignore: cast_nullable_to_non_nullable
          : totalExpense as double?,
      createdAt: createdAt == const $CopyWithPlaceholder() || createdAt == null
          // ignore: unnecessary_non_null_assertion
          ? _value.createdAt!
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
    );
  }
}

extension $BillDbModelCopyWith on BillDbModel {
  /// Returns a callable class that can be used as follows: `instanceOfBillDbModel.copyWith(...)` or like so:`instanceOfBillDbModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BillDbModelCWProxy get copyWith => _$BillDbModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillDbModel _$BillDbModelFromJson(Map<String, dynamic> json) => BillDbModel(
      id: json['id'] as int,
      cron: json['cron'] as String?,
      startAt: json['start_at'] == null
          ? null
          : DateTime.parse(json['start_at'] as String),
      finishAt: json['finish_at'] == null
          ? null
          : DateTime.parse(json['finish_at'] as String),
      title: json['title'] as String?,
      categoryId: json['category_id'] as int,
      lastTransactionId: json['last_transaction_id'] as int?,
      autoAddTranaction: json['auto_add_tranaction'] as bool,
      totalExpense: (json['total_expense'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$BillDbModelToJson(BillDbModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cron': instance.cron,
      'start_at': instance.startAt?.toIso8601String(),
      'finish_at': instance.finishAt?.toIso8601String(),
      'auto_add_tranaction': instance.autoAddTranaction,
      'title': instance.title,
      'last_transaction_id': instance.lastTransactionId,
      'category_id': instance.categoryId,
      'total_expense': instance.totalExpense,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
