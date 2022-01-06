import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/base_model.dart';

part 'story_model.g.dart';

@JsonSerializable()
class StoryModel extends BaseModel {
  final String? id;
  final bool? starred;
  final String? feeling;
  final String? title;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? plainText;

  // Returns JSON-serializable version of quill delta.
  final List<dynamic>? document;

  StoryModel({
    required this.id,
    required this.starred,
    required this.feeling,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.plainText,
    required this.document,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) => _$StoryModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StoryModelToJson(this);

  @override
  String? get objectId => id;
}
