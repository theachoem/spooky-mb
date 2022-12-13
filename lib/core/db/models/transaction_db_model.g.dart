// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_db_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TransactionDbModelCWProxy {
  TransactionDbModel id(int id);

  TransactionDbModel day(int day);

  TransactionDbModel month(int month);

  TransactionDbModel year(int year);

  TransactionDbModel time(int? time);

  TransactionDbModel specificDate(DateTime? specificDate);

  TransactionDbModel note(String? note);

  TransactionDbModel eventId(int? eventId);

  TransactionDbModel billingId(int? billingId);

  TransactionDbModel categoryId(int categoryId);

  TransactionDbModel createdAt(DateTime createdAt);

  TransactionDbModel updatedAt(DateTime? updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TransactionDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TransactionDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  TransactionDbModel call({
    int? id,
    int? day,
    int? month,
    int? year,
    int? time,
    DateTime? specificDate,
    String? note,
    int? eventId,
    int? billingId,
    int? categoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTransactionDbModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTransactionDbModel.copyWith.fieldName(...)`
class _$TransactionDbModelCWProxyImpl implements _$TransactionDbModelCWProxy {
  const _$TransactionDbModelCWProxyImpl(this._value);

  final TransactionDbModel _value;

  @override
  TransactionDbModel id(int id) => this(id: id);

  @override
  TransactionDbModel day(int day) => this(day: day);

  @override
  TransactionDbModel month(int month) => this(month: month);

  @override
  TransactionDbModel year(int year) => this(year: year);

  @override
  TransactionDbModel time(int? time) => this(time: time);

  @override
  TransactionDbModel specificDate(DateTime? specificDate) =>
      this(specificDate: specificDate);

  @override
  TransactionDbModel note(String? note) => this(note: note);

  @override
  TransactionDbModel eventId(int? eventId) => this(eventId: eventId);

  @override
  TransactionDbModel billingId(int? billingId) => this(billingId: billingId);

  @override
  TransactionDbModel categoryId(int categoryId) => this(categoryId: categoryId);

  @override
  TransactionDbModel createdAt(DateTime createdAt) =>
      this(createdAt: createdAt);

  @override
  TransactionDbModel updatedAt(DateTime? updatedAt) =>
      this(updatedAt: updatedAt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TransactionDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TransactionDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  TransactionDbModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? day = const $CopyWithPlaceholder(),
    Object? month = const $CopyWithPlaceholder(),
    Object? year = const $CopyWithPlaceholder(),
    Object? time = const $CopyWithPlaceholder(),
    Object? specificDate = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? eventId = const $CopyWithPlaceholder(),
    Object? billingId = const $CopyWithPlaceholder(),
    Object? categoryId = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return TransactionDbModel(
      id: id == const $CopyWithPlaceholder() || id == null
          // ignore: unnecessary_non_null_assertion
          ? _value.id!
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      day: day == const $CopyWithPlaceholder() || day == null
          // ignore: unnecessary_non_null_assertion
          ? _value.day!
          // ignore: cast_nullable_to_non_nullable
          : day as int,
      month: month == const $CopyWithPlaceholder() || month == null
          // ignore: unnecessary_non_null_assertion
          ? _value.month!
          // ignore: cast_nullable_to_non_nullable
          : month as int,
      year: year == const $CopyWithPlaceholder() || year == null
          // ignore: unnecessary_non_null_assertion
          ? _value.year!
          // ignore: cast_nullable_to_non_nullable
          : year as int,
      time: time == const $CopyWithPlaceholder()
          ? _value.time
          // ignore: cast_nullable_to_non_nullable
          : time as int?,
      specificDate: specificDate == const $CopyWithPlaceholder()
          ? _value.specificDate
          // ignore: cast_nullable_to_non_nullable
          : specificDate as DateTime?,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
      eventId: eventId == const $CopyWithPlaceholder()
          ? _value.eventId
          // ignore: cast_nullable_to_non_nullable
          : eventId as int?,
      billingId: billingId == const $CopyWithPlaceholder()
          ? _value.billingId
          // ignore: cast_nullable_to_non_nullable
          : billingId as int?,
      categoryId:
          categoryId == const $CopyWithPlaceholder() || categoryId == null
              // ignore: unnecessary_non_null_assertion
              ? _value.categoryId!
              // ignore: cast_nullable_to_non_nullable
              : categoryId as int,
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

extension $TransactionDbModelCopyWith on TransactionDbModel {
  /// Returns a callable class that can be used as follows: `instanceOfTransactionDbModel.copyWith(...)` or like so:`instanceOfTransactionDbModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TransactionDbModelCWProxy get copyWith =>
      _$TransactionDbModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionDbModel _$TransactionDbModelFromJson(Map<String, dynamic> json) =>
    TransactionDbModel(
      id: json['id'] as int,
      day: json['day'] as int,
      month: json['month'] as int,
      year: json['year'] as int,
      time: json['time'] as int?,
      specificDate: json['specific_date'] == null
          ? null
          : DateTime.parse(json['specific_date'] as String),
      note: json['note'] as String?,
      eventId: json['event_id'] as int?,
      billingId: json['billing_id'] as int?,
      categoryId: json['category_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$TransactionDbModelToJson(TransactionDbModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'day': instance.day,
      'month': instance.month,
      'year': instance.year,
      'time': instance.time,
      'specific_date': instance.specificDate?.toIso8601String(),
      'note': instance.note,
      'event_id': instance.eventId,
      'billing_id': instance.billingId,
      'category_id': instance.categoryId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
