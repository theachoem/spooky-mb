// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_v2_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StoryV2ModelCWProxy {
  StoryV2Model changes(List<StoryContentV2Model> changes);

  StoryV2Model day(int day);

  StoryV2Model feeling(String? feeling);

  StoryV2Model id(int id);

  StoryV2Model month(int month);

  StoryV2Model starred(bool? starred);

  StoryV2Model type(PathType type);

  StoryV2Model year(int year);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryV2Model(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryV2Model(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryV2Model call({
    List<StoryContentV2Model>? changes,
    int? day,
    String? feeling,
    int? id,
    int? month,
    bool? starred,
    PathType? type,
    int? year,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStoryV2Model.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStoryV2Model.copyWith.fieldName(...)`
class _$StoryV2ModelCWProxyImpl implements _$StoryV2ModelCWProxy {
  final StoryV2Model _value;

  const _$StoryV2ModelCWProxyImpl(this._value);

  @override
  StoryV2Model changes(List<StoryContentV2Model> changes) =>
      this(changes: changes);

  @override
  StoryV2Model day(int day) => this(day: day);

  @override
  StoryV2Model feeling(String? feeling) => this(feeling: feeling);

  @override
  StoryV2Model id(int id) => this(id: id);

  @override
  StoryV2Model month(int month) => this(month: month);

  @override
  StoryV2Model starred(bool? starred) => this(starred: starred);

  @override
  StoryV2Model type(PathType type) => this(type: type);

  @override
  StoryV2Model year(int year) => this(year: year);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryV2Model(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryV2Model(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryV2Model call({
    Object? changes = const $CopyWithPlaceholder(),
    Object? day = const $CopyWithPlaceholder(),
    Object? feeling = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? month = const $CopyWithPlaceholder(),
    Object? starred = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? year = const $CopyWithPlaceholder(),
  }) {
    return StoryV2Model(
      changes: changes == const $CopyWithPlaceholder() || changes == null
          ? _value.changes
          // ignore: cast_nullable_to_non_nullable
          : changes as List<StoryContentV2Model>,
      day: day == const $CopyWithPlaceholder() || day == null
          ? _value.day
          // ignore: cast_nullable_to_non_nullable
          : day as int,
      feeling: feeling == const $CopyWithPlaceholder()
          ? _value.feeling
          // ignore: cast_nullable_to_non_nullable
          : feeling as String?,
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      month: month == const $CopyWithPlaceholder() || month == null
          ? _value.month
          // ignore: cast_nullable_to_non_nullable
          : month as int,
      starred: starred == const $CopyWithPlaceholder()
          ? _value.starred
          // ignore: cast_nullable_to_non_nullable
          : starred as bool?,
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as PathType,
      year: year == const $CopyWithPlaceholder() || year == null
          ? _value.year
          // ignore: cast_nullable_to_non_nullable
          : year as int,
    );
  }
}

extension $StoryV2ModelCopyWith on StoryV2Model {
  /// Returns a callable class that can be used as follows: `instanceOfclass StoryV2Model extends BaseModel.name.copyWith(...)` or like so:`instanceOfclass StoryV2Model extends BaseModel.name.copyWith.fieldName(...)`.
  _$StoryV2ModelCWProxy get copyWith => _$StoryV2ModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryV2Model _$StoryV2ModelFromJson(Map<String, dynamic> json) => StoryV2Model(
      type: $enumDecode(_$PathTypeEnumMap, json['type']),
      id: json['id'] as int,
      starred: json['starred'] as bool?,
      feeling: json['feeling'] as String?,
      year: json['year'] as int,
      month: json['month'] as int,
      day: json['day'] as int,
      changes: (json['changes'] as List<dynamic>)
          .map((e) => StoryContentV2Model.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoryV2ModelToJson(StoryV2Model instance) =>
    <String, dynamic>{
      'type': _$PathTypeEnumMap[instance.type],
      'id': instance.id,
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
      'starred': instance.starred,
      'feeling': instance.feeling,
      'changes': instance.changes.map((e) => e.toJson()).toList(),
    };

const _$PathTypeEnumMap = {
  PathType.docs: 'docs',
  PathType.bins: 'bins',
  PathType.archives: 'archives',
};
