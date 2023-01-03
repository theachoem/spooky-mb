import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/types/sort_type.dart';
import 'package:spooky/widgets/sp_story_list/sp_story_list.dart';

part 'story_config_model.g.dart';

@JsonSerializable()
@CopyWith()
class StoryConfigModel {
  final SpListLayoutType? layoutType;
  final SortType? sortType;
  final bool? prioritied;
  final bool? disableDatePicker;

  StoryConfigModel({
    this.layoutType,
    this.sortType,
    this.prioritied,
    this.disableDatePicker,
  });

  Map<String, dynamic> toJson() => _$StoryConfigModelToJson(this);
  factory StoryConfigModel.fromJson(Map<String, dynamic> json) => _$StoryConfigModelFromJson(json);
}
