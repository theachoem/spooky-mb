// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_config_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StoryConfigModelCWProxy {
  StoryConfigModel layoutType(SpListLayoutType? layoutType);

  StoryConfigModel sortType(SortType? sortType);

  StoryConfigModel prioritied(bool? prioritied);

  StoryConfigModel disableDatePicker(bool? disableDatePicker);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryConfigModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryConfigModel(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryConfigModel call({
    SpListLayoutType? layoutType,
    SortType? sortType,
    bool? prioritied,
    bool? disableDatePicker,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStoryConfigModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStoryConfigModel.copyWith.fieldName(...)`
class _$StoryConfigModelCWProxyImpl implements _$StoryConfigModelCWProxy {
  const _$StoryConfigModelCWProxyImpl(this._value);

  final StoryConfigModel _value;

  @override
  StoryConfigModel layoutType(SpListLayoutType? layoutType) =>
      this(layoutType: layoutType);

  @override
  StoryConfigModel sortType(SortType? sortType) => this(sortType: sortType);

  @override
  StoryConfigModel prioritied(bool? prioritied) => this(prioritied: prioritied);

  @override
  StoryConfigModel disableDatePicker(bool? disableDatePicker) =>
      this(disableDatePicker: disableDatePicker);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryConfigModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryConfigModel(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryConfigModel call({
    Object? layoutType = const $CopyWithPlaceholder(),
    Object? sortType = const $CopyWithPlaceholder(),
    Object? prioritied = const $CopyWithPlaceholder(),
    Object? disableDatePicker = const $CopyWithPlaceholder(),
  }) {
    return StoryConfigModel(
      layoutType: layoutType == const $CopyWithPlaceholder()
          ? _value.layoutType
          // ignore: cast_nullable_to_non_nullable
          : layoutType as SpListLayoutType?,
      sortType: sortType == const $CopyWithPlaceholder()
          ? _value.sortType
          // ignore: cast_nullable_to_non_nullable
          : sortType as SortType?,
      prioritied: prioritied == const $CopyWithPlaceholder()
          ? _value.prioritied
          // ignore: cast_nullable_to_non_nullable
          : prioritied as bool?,
      disableDatePicker: disableDatePicker == const $CopyWithPlaceholder()
          ? _value.disableDatePicker
          // ignore: cast_nullable_to_non_nullable
          : disableDatePicker as bool?,
    );
  }
}

extension $StoryConfigModelCopyWith on StoryConfigModel {
  /// Returns a callable class that can be used as follows: `instanceOfStoryConfigModel.copyWith(...)` or like so:`instanceOfStoryConfigModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StoryConfigModelCWProxy get copyWith => _$StoryConfigModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryConfigModel _$StoryConfigModelFromJson(Map<String, dynamic> json) =>
    StoryConfigModel(
      layoutType:
          $enumDecodeNullable(_$SpListLayoutTypeEnumMap, json['layout_type']),
      sortType: $enumDecodeNullable(_$SortTypeEnumMap, json['sort_type']),
      prioritied: json['prioritied'] as bool?,
      disableDatePicker: json['disable_date_picker'] as bool?,
    );

Map<String, dynamic> _$StoryConfigModelToJson(StoryConfigModel instance) =>
    <String, dynamic>{
      'layout_type': _$SpListLayoutTypeEnumMap[instance.layoutType],
      'sort_type': _$SortTypeEnumMap[instance.sortType],
      'prioritied': instance.prioritied,
      'disable_date_picker': instance.disableDatePicker,
    };

const _$SpListLayoutTypeEnumMap = {
  SpListLayoutType.library: 'library',
  SpListLayoutType.diary: 'diary',
  SpListLayoutType.timeline: 'timeline',
};

const _$SortTypeEnumMap = {
  SortType.newToOld: 'newToOld',
  SortType.oldToNew: 'oldToNew',
};
