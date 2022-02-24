import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/utils/mixins/comparable_mixin.dart';

part 'story_content_model.g.dart';

@JsonSerializable()
class StoryContentModel extends BaseModel with ComparableMixin {
  final String id;
  final bool? starred;
  final String? feeling;
  final String? title;
  final String? plainText;
  final DateTime createdAt;
  final DateTime? updatedAt;

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
    this.updatedAt,
  });

  StoryContentModel copyWith({
    String? id,
    bool? starred,
    String? feeling,
    String? title,
    String? plainText,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<List<dynamic>>? pages,
  }) {
    return StoryContentModel(
      id: id ?? this.id,
      starred: starred ?? this.starred,
      feeling: feeling ?? this.feeling,
      title: title ?? this.title,
      plainText: plainText ?? this.plainText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pages: pages ?? this.pages,
    );
  }

  void addPage() {
    if (pages != null) {
      pages?.add([]);
    } else {
      pages = [[]];
    }
  }

  StoryContentModel restore(StoryContentModel oldContent) {
    DateTime now = DateTime.now();
    return oldContent.copyWith(
      id: now.millisecondsSinceEpoch.toString(),
      createdAt: now,
    );
  }

  StoryContentModel.create({
    required this.createdAt,
    required this.id,
  })  : starred = null,
        feeling = null,
        plainText = null,
        title = null,
        updatedAt = null,
        pages = [[]];

  @override
  Map<String, dynamic> toJson() => _$StoryContentModelToJson(this);
  factory StoryContentModel.fromJson(Map<String, dynamic> json) => _$StoryContentModelFromJson(json);

  @override
  String? get objectId => id;

  @override
  List<String> get excludeCompareKeys {
    return [
      'id',
      'plain_text',
      'created_at',
    ];
  }
}
