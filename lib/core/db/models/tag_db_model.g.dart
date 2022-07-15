// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_db_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TagDbModelCWProxy {
  TagDbModel createdAt(DateTime createdAt);

  TagDbModel emoji(String? emoji);

  TagDbModel id(int id);

  TagDbModel index(int? index);

  TagDbModel starred(bool? starred);

  TagDbModel title(String title);

  TagDbModel updatedAt(DateTime updatedAt);

  TagDbModel version(int version);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TagDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TagDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  TagDbModel call({
    DateTime? createdAt,
    String? emoji,
    int? id,
    int? index,
    bool? starred,
    String? title,
    DateTime? updatedAt,
    int? version,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTagDbModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTagDbModel.copyWith.fieldName(...)`
class _$TagDbModelCWProxyImpl implements _$TagDbModelCWProxy {
  final TagDbModel _value;

  const _$TagDbModelCWProxyImpl(this._value);

  @override
  TagDbModel createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  TagDbModel emoji(String? emoji) => this(emoji: emoji);

  @override
  TagDbModel id(int id) => this(id: id);

  @override
  TagDbModel index(int? index) => this(index: index);

  @override
  TagDbModel starred(bool? starred) => this(starred: starred);

  @override
  TagDbModel title(String title) => this(title: title);

  @override
  TagDbModel updatedAt(DateTime updatedAt) => this(updatedAt: updatedAt);

  @override
  TagDbModel version(int version) => this(version: version);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TagDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TagDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  TagDbModel call({
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? emoji = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? index = const $CopyWithPlaceholder(),
    Object? starred = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? version = const $CopyWithPlaceholder(),
  }) {
    return TagDbModel(
      createdAt: createdAt == const $CopyWithPlaceholder() || createdAt == null
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      emoji: emoji == const $CopyWithPlaceholder()
          ? _value.emoji
          // ignore: cast_nullable_to_non_nullable
          : emoji as String?,
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      index: index == const $CopyWithPlaceholder()
          ? _value.index
          // ignore: cast_nullable_to_non_nullable
          : index as int?,
      starred: starred == const $CopyWithPlaceholder()
          ? _value.starred
          // ignore: cast_nullable_to_non_nullable
          : starred as bool?,
      title: title == const $CopyWithPlaceholder() || title == null
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      updatedAt: updatedAt == const $CopyWithPlaceholder() || updatedAt == null
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime,
      version: version == const $CopyWithPlaceholder() || version == null
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as int,
    );
  }
}

extension $TagDbModelCopyWith on TagDbModel {
  /// Returns a callable class that can be used as follows: `instanceOfTagDbModel.copyWith(...)` or like so:`instanceOfTagDbModel.copyWith.fieldName(...)`.
  _$TagDbModelCWProxy get copyWith => _$TagDbModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagDbModel _$TagDbModelFromJson(Map<String, dynamic> json) => TagDbModel(
      id: json['id'] as int,
      version: json['version'] as int,
      title: json['title'] as String,
      starred: json['starred'] as bool?,
      emoji: json['emoji'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      index: json['index'] as int?,
    );

Map<String, dynamic> _$TagDbModelToJson(TagDbModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'index': instance.index,
      'version': instance.version,
      'title': instance.title,
      'starred': instance.starred,
      'emoji': instance.emoji,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
