import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/core/models/path_model.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/types/cloud_storage_type.dart';

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

  // sync infos
  final bool synced;
  final Map<String, String>? cloudIds;

  String? cloudID(CloudStorageType type) {
    if (cloudIds != null && cloudIds?.containsKey(type.name) == true) {
      return cloudIds?[type.name];
    }
    return null;
  }

  StoryModel({
    required this.id,
    required this.path,
    this.synced = false,
    this.file,
    this.changes = const [],
    this.cloudIds,
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
    bool? synced,
    Map<String, String>? cloudIds,
  }) {
    return StoryModel(
      id: id ?? this.id,
      path: path ?? this.path,
      file: file ?? this.file,
      changes: changes ?? this.changes,
      synced: synced ?? this.synced,
      cloudIds: cloudIds ?? this.cloudIds,
    );
  }

  bool get starred => changes.last.starred == true;
  StoryModel copyWithStarred(bool value) {
    StoryContentModel last = changes.removeLast();
    last = last.copyWith(starred: value, updatedAt: DateTime.now());
    changes.add(last);
    return this;
  }

  StoryModel copyWithSync(String id, CloudStorageType type) {
    Map<String, String> cloudIds = this.cloudIds ?? {};
    cloudIds[type.name] = id;
    return copyWith(synced: true, cloudIds: cloudIds);
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
