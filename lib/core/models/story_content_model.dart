import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/base_model.dart';

part 'story_content_model.g.dart';

@JsonSerializable()
class StoryContentModel extends BaseModel {
  final String id;
  final bool? starred;
  final String? feeling;
  final String? title;
  final String? plainText;
  final DateTime createdAt;

  // List: Returns JSON-serializable version of quill delta.
  List<List<dynamic>>? pages;

  StoryContentModel({
    required this.id,
    required this.starred,
    required this.feeling,
    required this.title,
    required this.plainText,
    required this.createdAt,
    required this.pages,
  });

  StoryContentModel.create(this.createdAt)
      : id = createdAt.millisecondsSinceEpoch.toString(),
        starred = null,
        feeling = null,
        plainText = null,
        title = null,
        pages = [[]];

  @override
  Map<String, dynamic> toJson() => _$StoryContentModelToJson(this);
  factory StoryContentModel.fromJson(Map<String, dynamic> json) => _$StoryContentModelFromJson(json);

  @override
  String? get objectId => id;
}
