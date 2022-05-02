// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_content_db_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StoryContentDbModelCWProxy {
  StoryContentDbModel createdAt(DateTime createdAt);

  StoryContentDbModel id(int id);

  StoryContentDbModel pages(List<List<dynamic>>? pages);

  StoryContentDbModel plainText(String? plainText);

  StoryContentDbModel title(String? title);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryContentDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryContentDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryContentDbModel call({
    DateTime? createdAt,
    int? id,
    List<List<dynamic>>? pages,
    String? plainText,
    String? title,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStoryContentDbModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStoryContentDbModel.copyWith.fieldName(...)`
class _$StoryContentDbModelCWProxyImpl implements _$StoryContentDbModelCWProxy {
  final StoryContentDbModel _value;

  const _$StoryContentDbModelCWProxyImpl(this._value);

  @override
  StoryContentDbModel createdAt(DateTime createdAt) =>
      this(createdAt: createdAt);

  @override
  StoryContentDbModel id(int id) => this(id: id);

  @override
  StoryContentDbModel pages(List<List<dynamic>>? pages) => this(pages: pages);

  @override
  StoryContentDbModel plainText(String? plainText) =>
      this(plainText: plainText);

  @override
  StoryContentDbModel title(String? title) => this(title: title);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryContentDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryContentDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryContentDbModel call({
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? pages = const $CopyWithPlaceholder(),
    Object? plainText = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
  }) {
    return StoryContentDbModel(
      createdAt: createdAt == const $CopyWithPlaceholder() || createdAt == null
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      pages: pages == const $CopyWithPlaceholder()
          ? _value.pages
          // ignore: cast_nullable_to_non_nullable
          : pages as List<List<dynamic>>?,
      plainText: plainText == const $CopyWithPlaceholder()
          ? _value.plainText
          // ignore: cast_nullable_to_non_nullable
          : plainText as String?,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String?,
    );
  }
}

extension $StoryContentDbModelCopyWith on StoryContentDbModel {
  /// Returns a callable class that can be used as follows: `instanceOfclass StoryContentDbModel extends BaseModel with ComparableMixin<BaseModel>.name.copyWith(...)` or like so:`instanceOfclass StoryContentDbModel extends BaseModel with ComparableMixin<BaseModel>.name.copyWith.fieldName(...)`.
  _$StoryContentDbModelCWProxy get copyWith =>
      _$StoryContentDbModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryContentDbModel _$StoryContentDbModelFromJson(Map<String, dynamic> json) =>
    StoryContentDbModel(
      id: json['id'] as int,
      title: json['title'] as String?,
      plainText: json['plain_text'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      pages: (json['pages'] as List<dynamic>?)
          ?.map((e) => e as List<dynamic>)
          .toList(),
    );

Map<String, dynamic> _$StoryContentDbModelToJson(
        StoryContentDbModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'plain_text': instance.plainText,
      'created_at': instance.createdAt.toIso8601String(),
      'pages': instance.pages,
    };
