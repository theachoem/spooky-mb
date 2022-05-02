import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/types/path_type.dart';

part 'story_db_model.g.dart';

@JsonSerializable()
class StoryDbModel extends BaseDbModel {
  final PathType type;
  final int id;

  final int year;
  final int month;
  final int day;

  final bool? starred;
  final String? feeling;

  final List<StoryContentDbModel> changes;

  StoryDbModel({
    required this.type,
    required this.id,
    required this.starred,
    required this.feeling,
    required this.year,
    required this.month,
    required this.day,
    required this.changes,
  });

  @override
  Map<String, dynamic> toJson() => _$StoryDbModelToJson(this);
  factory StoryDbModel.fromJson(Map<String, dynamic> json) => _$StoryDbModelFromJson(json);
}
