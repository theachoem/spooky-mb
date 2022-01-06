import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/story_content_model.dart';

part 'story_model.g.dart';

@JsonSerializable()
class StoryModel {
  final bool? starred;
  final String? feeling;
  final List<StoryContentModel>? changes;

  StoryModel({
    this.starred,
    this.feeling,
    this.changes,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) => _$StoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$StoryModelToJson(this);
}
