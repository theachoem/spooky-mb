// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_db_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StoryDbModelCWProxy {
  StoryDbModel version(int version);

  StoryDbModel type(PathType type);

  StoryDbModel id(int id);

  StoryDbModel starred(bool? starred);

  StoryDbModel feeling(String? feeling);

  StoryDbModel year(int year);

  StoryDbModel month(int month);

  StoryDbModel day(int day);

  StoryDbModel hour(int? hour);

  StoryDbModel minute(int? minute);

  StoryDbModel second(int? second);

  StoryDbModel changes(List<StoryContentDbModel> changes);

  StoryDbModel updatedAt(DateTime updatedAt);

  StoryDbModel createdAt(DateTime createdAt);

  StoryDbModel tags(List<String>? tags);

  StoryDbModel movedToBinAt(DateTime? movedToBinAt);

  StoryDbModel rawChanges(List<String>? rawChanges);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryDbModel call({
    int version,
    PathType type,
    int id,
    bool? starred,
    String? feeling,
    int year,
    int month,
    int day,
    int? hour,
    int? minute,
    int? second,
    List<StoryContentDbModel> changes,
    DateTime updatedAt,
    DateTime createdAt,
    List<String>? tags,
    DateTime? movedToBinAt,
    List<String>? rawChanges,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStoryDbModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStoryDbModel.copyWith.fieldName(...)`
class _$StoryDbModelCWProxyImpl implements _$StoryDbModelCWProxy {
  const _$StoryDbModelCWProxyImpl(this._value);

  final StoryDbModel _value;

  @override
  StoryDbModel version(int version) => this(version: version);

  @override
  StoryDbModel type(PathType type) => this(type: type);

  @override
  StoryDbModel id(int id) => this(id: id);

  @override
  StoryDbModel starred(bool? starred) => this(starred: starred);

  @override
  StoryDbModel feeling(String? feeling) => this(feeling: feeling);

  @override
  StoryDbModel year(int year) => this(year: year);

  @override
  StoryDbModel month(int month) => this(month: month);

  @override
  StoryDbModel day(int day) => this(day: day);

  @override
  StoryDbModel hour(int? hour) => this(hour: hour);

  @override
  StoryDbModel minute(int? minute) => this(minute: minute);

  @override
  StoryDbModel second(int? second) => this(second: second);

  @override
  StoryDbModel changes(List<StoryContentDbModel> changes) =>
      this(changes: changes);

  @override
  StoryDbModel updatedAt(DateTime updatedAt) => this(updatedAt: updatedAt);

  @override
  StoryDbModel createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  StoryDbModel tags(List<String>? tags) => this(tags: tags);

  @override
  StoryDbModel movedToBinAt(DateTime? movedToBinAt) =>
      this(movedToBinAt: movedToBinAt);

  @override
  StoryDbModel rawChanges(List<String>? rawChanges) =>
      this(rawChanges: rawChanges);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryDbModel call({
    Object? version = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? starred = const $CopyWithPlaceholder(),
    Object? feeling = const $CopyWithPlaceholder(),
    Object? year = const $CopyWithPlaceholder(),
    Object? month = const $CopyWithPlaceholder(),
    Object? day = const $CopyWithPlaceholder(),
    Object? hour = const $CopyWithPlaceholder(),
    Object? minute = const $CopyWithPlaceholder(),
    Object? second = const $CopyWithPlaceholder(),
    Object? changes = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
    Object? movedToBinAt = const $CopyWithPlaceholder(),
    Object? rawChanges = const $CopyWithPlaceholder(),
  }) {
    return StoryDbModel(
      version: version == const $CopyWithPlaceholder()
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as int,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as PathType,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      starred: starred == const $CopyWithPlaceholder()
          ? _value.starred
          // ignore: cast_nullable_to_non_nullable
          : starred as bool?,
      feeling: feeling == const $CopyWithPlaceholder()
          ? _value.feeling
          // ignore: cast_nullable_to_non_nullable
          : feeling as String?,
      year: year == const $CopyWithPlaceholder()
          ? _value.year
          // ignore: cast_nullable_to_non_nullable
          : year as int,
      month: month == const $CopyWithPlaceholder()
          ? _value.month
          // ignore: cast_nullable_to_non_nullable
          : month as int,
      day: day == const $CopyWithPlaceholder()
          ? _value.day
          // ignore: cast_nullable_to_non_nullable
          : day as int,
      hour: hour == const $CopyWithPlaceholder()
          ? _value.hour
          // ignore: cast_nullable_to_non_nullable
          : hour as int?,
      minute: minute == const $CopyWithPlaceholder()
          ? _value.minute
          // ignore: cast_nullable_to_non_nullable
          : minute as int?,
      second: second == const $CopyWithPlaceholder()
          ? _value.second
          // ignore: cast_nullable_to_non_nullable
          : second as int?,
      changes: changes == const $CopyWithPlaceholder()
          ? _value.changes
          // ignore: cast_nullable_to_non_nullable
          : changes as List<StoryContentDbModel>,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      tags: tags == const $CopyWithPlaceholder()
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<String>?,
      movedToBinAt: movedToBinAt == const $CopyWithPlaceholder()
          ? _value.movedToBinAt
          // ignore: cast_nullable_to_non_nullable
          : movedToBinAt as DateTime?,
      rawChanges: rawChanges == const $CopyWithPlaceholder()
          ? _value.rawChanges
          // ignore: cast_nullable_to_non_nullable
          : rawChanges as List<String>?,
    );
  }
}

extension $StoryDbModelCopyWith on StoryDbModel {
  /// Returns a callable class that can be used as follows: `instanceOfStoryDbModel.copyWith(...)` or like so:`instanceOfStoryDbModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StoryDbModelCWProxy get copyWith => _$StoryDbModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryDbModel _$StoryDbModelFromJson(Map<String, dynamic> json) => StoryDbModel(
      version: (json['version'] as num?)?.toInt() ?? 1,
      type: $enumDecode(_$PathTypeEnumMap, json['type']),
      id: (json['id'] as num).toInt(),
      starred: json['starred'] as bool?,
      feeling: json['feeling'] as String?,
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      day: (json['day'] as num).toInt(),
      hour: (json['hour'] as num?)?.toInt(),
      minute: (json['minute'] as num?)?.toInt(),
      second: (json['second'] as num?)?.toInt(),
      changes: (json['changes'] as List<dynamic>)
          .map((e) => StoryContentDbModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      movedToBinAt: json['moved_to_bin_at'] == null
          ? null
          : DateTime.parse(json['moved_to_bin_at'] as String),
      rawChanges: (json['raw_changes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$StoryDbModelToJson(StoryDbModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'type': _$PathTypeEnumMap[instance.type]!,
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
      'raw_changes': instance.rawChanges,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'moved_to_bin_at': instance.movedToBinAt?.toIso8601String(),
    };

const _$PathTypeEnumMap = {
  PathType.docs: 'docs',
  PathType.bins: 'bins',
  PathType.archives: 'archives',
};