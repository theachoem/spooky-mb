import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/base_route_model.dart';
import 'package:spooky/core/models/path_model.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/route/sp_route_config.dart';

part 'story_model.g.dart';

@JsonSerializable()
class StoryModel extends BaseRouteModel {
  final String id;
  final PathModel path;
  final File? file;
  final List<StoryContentModel> changes;

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

  @override
  String get displayRouteName => Detail.name;

  @override
  Map<String, String> get routePayload {
    return {
      "path": path.toPath(),
    };
  }
}
