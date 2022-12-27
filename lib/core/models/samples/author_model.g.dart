// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthorModelCWProxy {
  AuthorModel type(String? type);

  AuthorModel id(String? id);

  AuthorModel name(String? name);

  AuthorModel age(int? age);

  AuthorModel gender(String? gender);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthorModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthorModel(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthorModel call({
    String? type,
    String? id,
    String? name,
    int? age,
    String? gender,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthorModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuthorModel.copyWith.fieldName(...)`
class _$AuthorModelCWProxyImpl implements _$AuthorModelCWProxy {
  const _$AuthorModelCWProxyImpl(this._value);

  final AuthorModel _value;

  @override
  AuthorModel type(String? type) => this(type: type);

  @override
  AuthorModel id(String? id) => this(id: id);

  @override
  AuthorModel name(String? name) => this(name: name);

  @override
  AuthorModel age(int? age) => this(age: age);

  @override
  AuthorModel gender(String? gender) => this(gender: gender);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthorModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthorModel(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthorModel call({
    Object? type = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? age = const $CopyWithPlaceholder(),
    Object? gender = const $CopyWithPlaceholder(),
  }) {
    return AuthorModel(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String?,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      age: age == const $CopyWithPlaceholder()
          ? _value.age
          // ignore: cast_nullable_to_non_nullable
          : age as int?,
      gender: gender == const $CopyWithPlaceholder()
          ? _value.gender
          // ignore: cast_nullable_to_non_nullable
          : gender as String?,
    );
  }
}

extension $AuthorModelCopyWith on AuthorModel {
  /// Returns a callable class that can be used as follows: `instanceOfAuthorModel.copyWith(...)` or like so:`instanceOfAuthorModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthorModelCWProxy get copyWith => _$AuthorModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorModel _$AuthorModelFromJson(Map<String, dynamic> json) => AuthorModel(
      type: json['type'] as String?,
      id: json['id'] as String?,
      name: json['name'] as String?,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
    );

Map<String, dynamic> _$AuthorModelToJson(AuthorModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'gender': instance.gender,
    };
