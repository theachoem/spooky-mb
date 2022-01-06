import 'package:json_annotation/json_annotation.dart';

part 'story_content_model.g.dart';

@JsonSerializable()
class StoryContentModel {
  // Returns JSON-serializable version of quill delta.
  final List<dynamic>? document;
  final String? id;
  final String? title;
  final DateTime? createOn;

  StoryContentModel({
    required this.id,
    required this.document,
    required this.title,
    required this.createOn,
  });

  factory StoryContentModel.fromJson(Map<String, dynamic> json) => _$StoryContentModelFromJson(json);
  Map<String, dynamic> toJson() => _$StoryContentModelToJson(this);
}
