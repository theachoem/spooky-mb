import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/types/path_type.dart';

part 'story_query_options_model.g.dart';

@JsonSerializable()
class StoryQueryOptionsModel {
  final int? year;
  final int? month;
  final int? day;
  final String? tag;
  final PathType type;

  StoryQueryOptionsModel({
    this.year,
    this.month,
    this.day,
    this.tag,
    required this.type,
  });

  String join() {
    List<String> paths = [
      type.name,
      if (year != null) "$year",
      if (month != null) "$month",
      if (day != null) "$day",
    ];
    return paths.join("/");
  }

  // docs/2021/1/12
  // String toPath([String? parent]) {
  //   List<String> paths = [
  //     // parent ?? FileHelper.directory.absolute.path,
  //     // type.name,
  //     // if (year != null) "$year",
  //     // if (month != null) "$month",
  //     // if (day != null) "$day",
  //   ];
  //   return paths.join("/");
  // }

  Map<String, dynamic> toJson() => _$StoryQueryOptionsModelToJson(this);
  factory StoryQueryOptionsModel.fromJson(Map<String, dynamic> json) => _$StoryQueryOptionsModelFromJson(json);
}
