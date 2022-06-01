// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BackupModelCWProxy {
  BackupModel createdAt(DateTime createdAt);

  BackupModel id(String id);

  BackupModel stories(List<StoryDbModel> stories);

  BackupModel version(int? version);

  BackupModel year(int year);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BackupModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BackupModel(...).copyWith(id: 12, name: "My name")
  /// ````
  BackupModel call({
    DateTime? createdAt,
    String? id,
    List<StoryDbModel>? stories,
    int? version,
    int? year,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBackupModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBackupModel.copyWith.fieldName(...)`
class _$BackupModelCWProxyImpl implements _$BackupModelCWProxy {
  final BackupModel _value;

  const _$BackupModelCWProxyImpl(this._value);

  @override
  BackupModel createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  BackupModel id(String id) => this(id: id);

  @override
  BackupModel stories(List<StoryDbModel> stories) => this(stories: stories);

  @override
  BackupModel version(int? version) => this(version: version);

  @override
  BackupModel year(int year) => this(year: year);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BackupModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BackupModel(...).copyWith(id: 12, name: "My name")
  /// ````
  BackupModel call({
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? stories = const $CopyWithPlaceholder(),
    Object? version = const $CopyWithPlaceholder(),
    Object? year = const $CopyWithPlaceholder(),
  }) {
    return BackupModel(
      createdAt: createdAt == const $CopyWithPlaceholder() || createdAt == null
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      stories: stories == const $CopyWithPlaceholder() || stories == null
          ? _value.stories
          // ignore: cast_nullable_to_non_nullable
          : stories as List<StoryDbModel>,
      version: version == const $CopyWithPlaceholder()
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as int?,
      year: year == const $CopyWithPlaceholder() || year == null
          ? _value.year
          // ignore: cast_nullable_to_non_nullable
          : year as int,
    );
  }
}

extension $BackupModelCopyWith on BackupModel {
  /// Returns a callable class that can be used as follows: `instanceOfBackupModel.copyWith(...)` or like so:`instanceOfBackupModel.copyWith.fieldName(...)`.
  _$BackupModelCWProxy get copyWith => _$BackupModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackupModel _$BackupModelFromJson(Map<String, dynamic> json) => BackupModel(
      version: json['version'] as int? ?? 1,
      year: json['year'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      stories: (json['stories'] as List<dynamic>)
          .map((e) => StoryDbModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BackupModelToJson(BackupModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'year': instance.year,
      'created_at': instance.createdAt.toIso8601String(),
      'stories': instance.stories.map((e) => e.toJson()).toList(),
    };
