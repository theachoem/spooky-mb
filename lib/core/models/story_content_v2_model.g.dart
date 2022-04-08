// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_content_v2_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StoryContentV2ModelCWProxy {
  StoryContentV2Model createdAt(DateTime createdAt);

  StoryContentV2Model id(int id);

  StoryContentV2Model pages(List<List<dynamic>>? pages);

  StoryContentV2Model plainText(String? plainText);

  StoryContentV2Model title(String? title);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryContentV2Model(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryContentV2Model(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryContentV2Model call({
    DateTime? createdAt,
    int? id,
    List<List<dynamic>>? pages,
    String? plainText,
    String? title,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStoryContentV2Model.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStoryContentV2Model.copyWith.fieldName(...)`
class _$StoryContentV2ModelCWProxyImpl implements _$StoryContentV2ModelCWProxy {
  final StoryContentV2Model _value;

  const _$StoryContentV2ModelCWProxyImpl(this._value);

  @override
  StoryContentV2Model createdAt(DateTime createdAt) =>
      this(createdAt: createdAt);

  @override
  StoryContentV2Model id(int id) => this(id: id);

  @override
  StoryContentV2Model pages(List<List<dynamic>>? pages) => this(pages: pages);

  @override
  StoryContentV2Model plainText(String? plainText) =>
      this(plainText: plainText);

  @override
  StoryContentV2Model title(String? title) => this(title: title);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryContentV2Model(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryContentV2Model(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryContentV2Model call({
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? pages = const $CopyWithPlaceholder(),
    Object? plainText = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
  }) {
    return StoryContentV2Model(
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

extension $StoryContentV2ModelCopyWith on StoryContentV2Model {
  /// Returns a callable class that can be used as follows: `instanceOfclass StoryContentV2Model extends BaseModel with ComparableMixin<BaseModel>.name.copyWith(...)` or like so:`instanceOfclass StoryContentV2Model extends BaseModel with ComparableMixin<BaseModel>.name.copyWith.fieldName(...)`.
  _$StoryContentV2ModelCWProxy get copyWith =>
      _$StoryContentV2ModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryContentV2Model _$StoryContentV2ModelFromJson(Map<String, dynamic> json) =>
    StoryContentV2Model(
      id: json['id'] as int,
      title: json['title'] as String?,
      plainText: json['plain_text'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      pages: (json['pages'] as List<dynamic>?)
          ?.map((e) => e as List<dynamic>)
          .toList(),
    );

Map<String, dynamic> _$StoryContentV2ModelToJson(
        StoryContentV2Model instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'plain_text': instance.plainText,
      'created_at': instance.createdAt.toIso8601String(),
      'pages': instance.pages,
    };
