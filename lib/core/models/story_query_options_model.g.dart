// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_query_options_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StoryQueryOptionsModelCWProxy {
  StoryQueryOptionsModel day(int? day);

  StoryQueryOptionsModel month(int? month);

  StoryQueryOptionsModel query(String? query);

  StoryQueryOptionsModel starred(bool? starred);

  StoryQueryOptionsModel tag(String? tag);

  StoryQueryOptionsModel type(PathType? type);

  StoryQueryOptionsModel year(int? year);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryQueryOptionsModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryQueryOptionsModel(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryQueryOptionsModel call({
    int? day,
    int? month,
    String? query,
    bool? starred,
    String? tag,
    PathType? type,
    int? year,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStoryQueryOptionsModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStoryQueryOptionsModel.copyWith.fieldName(...)`
class _$StoryQueryOptionsModelCWProxyImpl
    implements _$StoryQueryOptionsModelCWProxy {
  final StoryQueryOptionsModel _value;

  const _$StoryQueryOptionsModelCWProxyImpl(this._value);

  @override
  StoryQueryOptionsModel day(int? day) => this(day: day);

  @override
  StoryQueryOptionsModel month(int? month) => this(month: month);

  @override
  StoryQueryOptionsModel query(String? query) => this(query: query);

  @override
  StoryQueryOptionsModel starred(bool? starred) => this(starred: starred);

  @override
  StoryQueryOptionsModel tag(String? tag) => this(tag: tag);

  @override
  StoryQueryOptionsModel type(PathType? type) => this(type: type);

  @override
  StoryQueryOptionsModel year(int? year) => this(year: year);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryQueryOptionsModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryQueryOptionsModel(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryQueryOptionsModel call({
    Object? day = const $CopyWithPlaceholder(),
    Object? month = const $CopyWithPlaceholder(),
    Object? query = const $CopyWithPlaceholder(),
    Object? starred = const $CopyWithPlaceholder(),
    Object? tag = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? year = const $CopyWithPlaceholder(),
  }) {
    return StoryQueryOptionsModel(
      day: day == const $CopyWithPlaceholder()
          ? _value.day
          // ignore: cast_nullable_to_non_nullable
          : day as int?,
      month: month == const $CopyWithPlaceholder()
          ? _value.month
          // ignore: cast_nullable_to_non_nullable
          : month as int?,
      query: query == const $CopyWithPlaceholder()
          ? _value.query
          // ignore: cast_nullable_to_non_nullable
          : query as String?,
      starred: starred == const $CopyWithPlaceholder()
          ? _value.starred
          // ignore: cast_nullable_to_non_nullable
          : starred as bool?,
      tag: tag == const $CopyWithPlaceholder()
          ? _value.tag
          // ignore: cast_nullable_to_non_nullable
          : tag as String?,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as PathType?,
      year: year == const $CopyWithPlaceholder()
          ? _value.year
          // ignore: cast_nullable_to_non_nullable
          : year as int?,
    );
  }
}

extension $StoryQueryOptionsModelCopyWith on StoryQueryOptionsModel {
  /// Returns a callable class that can be used as follows: `instanceOfStoryQueryOptionsModel.copyWith(...)` or like so:`instanceOfStoryQueryOptionsModel.copyWith.fieldName(...)`.
  _$StoryQueryOptionsModelCWProxy get copyWith =>
      _$StoryQueryOptionsModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryQueryOptionsModel _$StoryQueryOptionsModelFromJson(
        Map<String, dynamic> json) =>
    StoryQueryOptionsModel(
      year: json['year'] as int?,
      month: json['month'] as int?,
      day: json['day'] as int?,
      tag: json['tag'] as String?,
      starred: json['starred'] as bool? ?? false,
      query: json['query'] as String?,
      type: $enumDecodeNullable(_$PathTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$StoryQueryOptionsModelToJson(
        StoryQueryOptionsModel instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
      'tag': instance.tag,
      'type': _$PathTypeEnumMap[instance.type],
      'starred': instance.starred,
      'query': instance.query,
    };

const _$PathTypeEnumMap = {
  PathType.docs: 'docs',
  PathType.bins: 'bins',
  PathType.archives: 'archives',
};
