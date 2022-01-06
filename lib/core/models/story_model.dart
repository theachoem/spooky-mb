import 'package:json_annotation/json_annotation.dart';

part 'story_model.g.dart';

@JsonSerializable()
class StoryModel {
  // Returns JSON-serializable version of quill delta.
  final String? id;
  final bool? starred;
  final String? feeling;
  final String? title;
  final DateTime? forDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? plainText;
  final List<dynamic>? document;

  StoryModel({
    required this.id,
    required this.starred,
    required this.feeling,
    required this.title,
    required this.forDate,
    required this.createdAt,
    required this.updatedAt,
    required this.plainText,
    required this.document,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) => _$StoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$StoryModelToJson(this);
}
