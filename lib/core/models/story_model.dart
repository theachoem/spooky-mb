import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/core/models/path_model.dart';
import 'package:spooky/core/models/story_content_model.dart';

part 'story_model.g.dart';

@JsonSerializable()
class StoryModel extends BaseModel {
  final String id;
  final PathModel path;
  final List<StoryContentModel> changes;

  StoryModel({
    required this.id,
    required this.path,
    this.changes = const [],
  });

  factory StoryModel.fromNow() {
    final now = DateTime.now();
    return StoryModel(
      id: now.millisecondsSinceEpoch.toString(),
      path: PathModel.fromDateTime(now),
      changes: [
        StoryContentModel.create(now),
      ],
    );
  }

  StoryModel copyWith({
    String? id,
    PathModel? path,
    List<StoryContentModel>? changes,
  }) {
    return StoryModel(
      id: id ?? this.id,
      path: path ?? this.path,
      changes: changes ?? this.changes,
    );
  }

  void removeChangeById(String id) {
    return changes.removeWhere((e) => e.id == id);
  }

  void addChange(StoryContentModel content) {
    removeChangeById(content.id);
    changes.add(content);
  }

  @override
  Map<String, dynamic> toJson() => _$StoryModelToJson(this);
  factory StoryModel.fromJson(Map<String, dynamic> json) => _$StoryModelFromJson(json);

  @override
  String? get objectId => id;
}
