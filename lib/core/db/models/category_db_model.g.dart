// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_db_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CategoryDbModelCWProxy {
  CategoryDbModel id(int id);

  CategoryDbModel position(int position);

  CategoryDbModel type(String type);

  CategoryDbModel name(String name);

  CategoryDbModel budget(double? budget);

  CategoryDbModel icon(String? icon);

  CategoryDbModel createdAt(DateTime createdAt);

  CategoryDbModel updatedAt(DateTime? updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CategoryDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CategoryDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  CategoryDbModel call({
    int? id,
    int? position,
    String? type,
    String? name,
    double? budget,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCategoryDbModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCategoryDbModel.copyWith.fieldName(...)`
class _$CategoryDbModelCWProxyImpl implements _$CategoryDbModelCWProxy {
  const _$CategoryDbModelCWProxyImpl(this._value);

  final CategoryDbModel _value;

  @override
  CategoryDbModel id(int id) => this(id: id);

  @override
  CategoryDbModel position(int position) => this(position: position);

  @override
  CategoryDbModel type(String type) => this(type: type);

  @override
  CategoryDbModel name(String name) => this(name: name);

  @override
  CategoryDbModel budget(double? budget) => this(budget: budget);

  @override
  CategoryDbModel icon(String? icon) => this(icon: icon);

  @override
  CategoryDbModel createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  CategoryDbModel updatedAt(DateTime? updatedAt) => this(updatedAt: updatedAt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CategoryDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CategoryDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  CategoryDbModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? position = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? budget = const $CopyWithPlaceholder(),
    Object? icon = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return CategoryDbModel(
      id: id == const $CopyWithPlaceholder() || id == null
          // ignore: unnecessary_non_null_assertion
          ? _value.id!
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      position: position == const $CopyWithPlaceholder() || position == null
          // ignore: unnecessary_non_null_assertion
          ? _value.position!
          // ignore: cast_nullable_to_non_nullable
          : position as int,
      type: type == const $CopyWithPlaceholder() || type == null
          // ignore: unnecessary_non_null_assertion
          ? _value.type!
          // ignore: cast_nullable_to_non_nullable
          : type as String,
      name: name == const $CopyWithPlaceholder() || name == null
          // ignore: unnecessary_non_null_assertion
          ? _value.name!
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      budget: budget == const $CopyWithPlaceholder()
          ? _value.budget
          // ignore: cast_nullable_to_non_nullable
          : budget as double?,
      icon: icon == const $CopyWithPlaceholder()
          ? _value.icon
          // ignore: cast_nullable_to_non_nullable
          : icon as String?,
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

extension $CategoryDbModelCopyWith on CategoryDbModel {
  /// Returns a callable class that can be used as follows: `instanceOfCategoryDbModel.copyWith(...)` or like so:`instanceOfCategoryDbModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CategoryDbModelCWProxy get copyWith => _$CategoryDbModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryDbModel _$CategoryDbModelFromJson(Map<String, dynamic> json) =>
    CategoryDbModel(
      id: json['id'] as int,
      position: json['position'] as int,
      type: json['type'] as String,
      name: json['name'] as String,
      budget: (json['budget'] as num?)?.toDouble(),
      icon: json['icon'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CategoryDbModelToJson(CategoryDbModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'position': instance.position,
      'type': instance.type,
      'name': instance.name,
      'budget': instance.budget,
      'icon': instance.icon,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
