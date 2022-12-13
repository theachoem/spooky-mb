// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_db_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventDbModelCWProxy {
  EventDbModel id(int id);

  EventDbModel budget(double? budget);

  EventDbModel title(String? title);

  EventDbModel lastTransactionId(int? lastTransactionId);

  EventDbModel totalExpense(double totalExpense);

  EventDbModel startAt(DateTime? startAt);

  EventDbModel finishAt(DateTime? finishAt);

  EventDbModel createdAt(DateTime createdAt);

  EventDbModel updatedAt(DateTime? updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EventDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EventDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  EventDbModel call({
    int? id,
    double? budget,
    String? title,
    int? lastTransactionId,
    double? totalExpense,
    DateTime? startAt,
    DateTime? finishAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfEventDbModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfEventDbModel.copyWith.fieldName(...)`
class _$EventDbModelCWProxyImpl implements _$EventDbModelCWProxy {
  const _$EventDbModelCWProxyImpl(this._value);

  final EventDbModel _value;

  @override
  EventDbModel id(int id) => this(id: id);

  @override
  EventDbModel budget(double? budget) => this(budget: budget);

  @override
  EventDbModel title(String? title) => this(title: title);

  @override
  EventDbModel lastTransactionId(int? lastTransactionId) =>
      this(lastTransactionId: lastTransactionId);

  @override
  EventDbModel totalExpense(double totalExpense) =>
      this(totalExpense: totalExpense);

  @override
  EventDbModel startAt(DateTime? startAt) => this(startAt: startAt);

  @override
  EventDbModel finishAt(DateTime? finishAt) => this(finishAt: finishAt);

  @override
  EventDbModel createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  EventDbModel updatedAt(DateTime? updatedAt) => this(updatedAt: updatedAt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EventDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EventDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  EventDbModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? budget = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? lastTransactionId = const $CopyWithPlaceholder(),
    Object? totalExpense = const $CopyWithPlaceholder(),
    Object? startAt = const $CopyWithPlaceholder(),
    Object? finishAt = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return EventDbModel(
      id: id == const $CopyWithPlaceholder() || id == null
          // ignore: unnecessary_non_null_assertion
          ? _value.id!
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      budget: budget == const $CopyWithPlaceholder()
          ? _value.budget
          // ignore: cast_nullable_to_non_nullable
          : budget as double?,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String?,
      lastTransactionId: lastTransactionId == const $CopyWithPlaceholder()
          ? _value.lastTransactionId
          // ignore: cast_nullable_to_non_nullable
          : lastTransactionId as int?,
      totalExpense:
          totalExpense == const $CopyWithPlaceholder() || totalExpense == null
              // ignore: unnecessary_non_null_assertion
              ? _value.totalExpense!
              // ignore: cast_nullable_to_non_nullable
              : totalExpense as double,
      startAt: startAt == const $CopyWithPlaceholder()
          ? _value.startAt
          // ignore: cast_nullable_to_non_nullable
          : startAt as DateTime?,
      finishAt: finishAt == const $CopyWithPlaceholder()
          ? _value.finishAt
          // ignore: cast_nullable_to_non_nullable
          : finishAt as DateTime?,
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

extension $EventDbModelCopyWith on EventDbModel {
  /// Returns a callable class that can be used as follows: `instanceOfEventDbModel.copyWith(...)` or like so:`instanceOfEventDbModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventDbModelCWProxy get copyWith => _$EventDbModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventDbModel _$EventDbModelFromJson(Map<String, dynamic> json) => EventDbModel(
      id: json['id'] as int,
      budget: (json['budget'] as num?)?.toDouble(),
      title: json['title'] as String?,
      lastTransactionId: json['last_transaction_id'] as int?,
      totalExpense: (json['total_expense'] as num).toDouble(),
      startAt: json['start_at'] == null
          ? null
          : DateTime.parse(json['start_at'] as String),
      finishAt: json['finish_at'] == null
          ? null
          : DateTime.parse(json['finish_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$EventDbModelToJson(EventDbModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budget': instance.budget,
      'title': instance.title,
      'last_transaction_id': instance.lastTransactionId,
      'total_expense': instance.totalExpense,
      'start_at': instance.startAt?.toIso8601String(),
      'finish_at': instance.finishAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
