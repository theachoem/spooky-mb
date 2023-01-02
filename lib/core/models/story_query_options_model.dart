import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/core/types/sort_type.dart';

part 'story_query_options_model.g.dart';

@CopyWith()
@JsonSerializable()
class StoryQueryOptionsModel {
  final int? year;
  final int? month;
  final int? day;
  final String? tag;
  final PathType? type;
  final bool? starred;
  final String? query;
  final SortType? sortBy;
  final List<int>? selectedYears;
  final List<int>? yearsRange;

  StoryQueryOptionsModel({
    this.year,
    this.month,
    this.day,
    this.tag,
    this.starred = false,
    this.query,
    this.type,
    this.selectedYears,
    this.yearsRange,
    this.sortBy,
  });

  String join() {
    final list = toJson().entries.where((e) => e.value != null).map((e) => "${e.key}:${e.value}");
    return list.join("|");
  }

  Map<String, dynamic> toJson() => _$StoryQueryOptionsModelToJson(this);
  factory StoryQueryOptionsModel.fromJson(Map<String, dynamic> json) => _$StoryQueryOptionsModelFromJson(json);
}
