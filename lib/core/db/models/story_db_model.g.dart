// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_db_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StoryDbModelCWProxy {
  StoryDbModel changes(List<StoryContentDbModel> changes);

  StoryDbModel createdAt(DateTime createdAt);

  StoryDbModel day(int day);

  StoryDbModel feeling(String? feeling);

  StoryDbModel hour(int? hour);

  StoryDbModel id(int id);

  StoryDbModel minute(int? minute);

  StoryDbModel month(int month);

  StoryDbModel movedToBinAt(DateTime? movedToBinAt);

  StoryDbModel second(int? second);

  StoryDbModel starred(bool? starred);

  StoryDbModel tags(List<String>? tags);

  StoryDbModel type(PathType type);

  StoryDbModel updatedAt(DateTime updatedAt);

  StoryDbModel version(int version);

  StoryDbModel year(int year);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryDbModel call({
    List<StoryContentDbModel>? changes,
    DateTime? createdAt,
    int? day,
    String? feeling,
    int? hour,
    int? id,
    int? minute,
    int? month,
    DateTime? movedToBinAt,
    int? second,
    bool? starred,
    List<String>? tags,
    PathType? type,
    DateTime? updatedAt,
    int? version,
    int? year,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStoryDbModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStoryDbModel.copyWith.fieldName(...)`
class _$StoryDbModelCWProxyImpl implements _$StoryDbModelCWProxy {
  final StoryDbModel _value;

  const _$StoryDbModelCWProxyImpl(this._value);

  @override
  StoryDbModel changes(List<StoryContentDbModel> changes) =>
      this(changes: changes);

  @override
  StoryDbModel createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  StoryDbModel day(int day) => this(day: day);

  @override
  StoryDbModel feeling(String? feeling) => this(feeling: feeling);

  @override
  StoryDbModel hour(int? hour) => this(hour: hour);

  @override
  StoryDbModel id(int id) => this(id: id);

  @override
  StoryDbModel minute(int? minute) => this(minute: minute);

  @override
  StoryDbModel month(int month) => this(month: month);

  @override
  StoryDbModel movedToBinAt(DateTime? movedToBinAt) =>
      this(movedToBinAt: movedToBinAt);

  @override
  StoryDbModel second(int? second) => this(second: second);

  @override
  StoryDbModel starred(bool? starred) => this(starred: starred);

  @override
  StoryDbModel tags(List<String>? tags) => this(tags: tags);

  @override
  StoryDbModel type(PathType type) => this(type: type);

  @override
  StoryDbModel updatedAt(DateTime updatedAt) => this(updatedAt: updatedAt);

  @override
  StoryDbModel version(int version) => this(version: version);

  @override
  StoryDbModel year(int year) => this(year: year);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryDbModel call({
    Object? changes = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? day = const $CopyWithPlaceholder(),
    Object? feeling = const $CopyWithPlaceholder(),
    Object? hour = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? minute = const $CopyWithPlaceholder(),
    Object? month = const $CopyWithPlaceholder(),
    Object? movedToBinAt = const $CopyWithPlaceholder(),
    Object? second = const $CopyWithPlaceholder(),
    Object? starred = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? version = const $CopyWithPlaceholder(),
    Object? year = const $CopyWithPlaceholder(),
  }) {
    return StoryDbModel(
      changes: changes == const $CopyWithPlaceholder() || changes == null
          ? _value.changes
          // ignore: cast_nullable_to_non_nullable
          : changes as List<StoryContentDbModel>,
      createdAt: createdAt == const $CopyWithPlaceholder() || createdAt == null
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      day: day == const $CopyWithPlaceholder() || day == null
          ? _value.day
          // ignore: cast_nullable_to_non_nullable
          : day as int,
      feeling: feeling == const $CopyWithPlaceholder()
          ? _value.feeling
          // ignore: cast_nullable_to_non_nullable
          : feeling as String?,
      hour: hour == const $CopyWithPlaceholder()
          ? _value.hour
          // ignore: cast_nullable_to_non_nullable
          : hour as int?,
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      minute: minute == const $CopyWithPlaceholder()
          ? _value.minute
          // ignore: cast_nullable_to_non_nullable
          : minute as int?,
      month: month == const $CopyWithPlaceholder() || month == null
          ? _value.month
          // ignore: cast_nullable_to_non_nullable
          : month as int,
      movedToBinAt: movedToBinAt == const $CopyWithPlaceholder()
          ? _value.movedToBinAt
          // ignore: cast_nullable_to_non_nullable
          : movedToBinAt as DateTime?,
      second: second == const $CopyWithPlaceholder()
          ? _value.second
          // ignore: cast_nullable_to_non_nullable
          : second as int?,
      starred: starred == const $CopyWithPlaceholder()
          ? _value.starred
          // ignore: cast_nullable_to_non_nullable
          : starred as bool?,
      tags: tags == const $CopyWithPlaceholder()
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<String>?,
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as PathType,
      updatedAt: updatedAt == const $CopyWithPlaceholder() || updatedAt == null
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime,
      version: version == const $CopyWithPlaceholder() || version == null
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as int,
      year: year == const $CopyWithPlaceholder() || year == null
          ? _value.year
          // ignore: cast_nullable_to_non_nullable
          : year as int,
    );
  }
}

extension $StoryDbModelCopyWith on StoryDbModel {
  /// Returns a callable class that can be used as follows: `instanceOfStoryDbModel.copyWith(...)` or like so:`instanceOfStoryDbModel.copyWith.fieldName(...)`.
  _$StoryDbModelCWProxy get copyWith => _$StoryDbModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryDbModel _$StoryDbModelFromJson(Map<String, dynamic> json) => StoryDbModel(
      version: json['version'] as int? ?? 1,
      type: $enumDecode(_$PathTypeEnumMap, json['type']),
      id: json['id'] as int,
      starred: json['starred'] as bool?,
      feeling: json['feeling'] as String?,
      year: json['year'] as int,
      month: json['month'] as int,
      day: json['day'] as int,
      hour: json['hour'] as int?,
      minute: json['minute'] as int?,
      second: json['second'] as int?,
      changes: (json['changes'] as List<dynamic>)
          .map((e) => StoryContentDbModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      movedToBinAt: json['moved_to_bin_at'] == null
          ? null
          : DateTime.parse(json['moved_to_bin_at'] as String),
    );

Map<String, dynamic> _$StoryDbModelToJson(StoryDbModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'type': _$PathTypeEnumMap[instance.type],
      'id': instance.id,
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'starred': instance.starred,
      'feeling': instance.feeling,
      'tags': instance.tags,
      'changes': instance.changes.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'moved_to_bin_at': instance.movedToBinAt?.toIso8601String(),
    };

const _$PathTypeEnumMap = {
  PathType.docs: 'docs',
  PathType.bins: 'bins',
  PathType.archives: 'archives',
};
