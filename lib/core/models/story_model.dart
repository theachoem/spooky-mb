import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/core/models/path_model.dart';
import 'package:spooky/core/models/story_content_model.dart';

part 'story_model.g.dart';

@JsonSerializable()
class StoryModel extends BaseModel {
  final String id;

  // path model is sorted when display to user.
  // its date also display in monogram
  final PathModel path;
  final List<StoryContentModel> changes;

  @JsonKey(ignore: true)
  final File? file;

  @JsonKey(ignore: true)
  File get writableFile => file ?? path.toFile();

  StoryModel({
    required this.id,
    required this.path,
    this.file,
    this.changes = const [],
  });

  factory StoryModel.fromNow() {
    final now = DateTime.now();
    return StoryModel.fromDate(now);
  }

  // use date for only path
  factory StoryModel.fromDate(DateTime date) {
    final now = DateTime.now();
    return StoryModel(
      id: now.millisecondsSinceEpoch.toString(),
      path: PathModel.fromDateTime(date),
      changes: [
        StoryContentModel.create(createdAt: now, id: now.millisecondsSinceEpoch.toString()),
      ],
    );
  }

  StoryModel copyWith({
    String? id,
    PathModel? path,
    File? file,
    List<StoryContentModel>? changes,
  }) {
    return StoryModel(
      id: id ?? this.id,
      path: path ?? this.path,
      file: file ?? this.file,
      changes: changes ?? this.changes,
    );
  }

  bool get starred => changes.last.starred == true;
  StoryModel copyWithStarred(bool value) {
    StoryContentModel last = changes.removeLast();
    last = last.copyWith(starred: value, updatedAt: DateTime.now());
    changes.add(last);
    return this;
  }

  void removeChangeById(String id) {
    return changes.removeWhere((e) => e.id == id);
  }

  void removeChangeByIds(List<String> ids) {
    return changes.removeWhere((e) => ids.contains(e.id));
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
