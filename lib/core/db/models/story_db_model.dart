// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/services/story_tags_service.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
part 'story_db_model.g.dart';

@CopyWith()
@JsonSerializable()
class StoryDbModel extends BaseDbModel {
  final int version;
  final PathType type;
  final int id;

  final int year;
  final int month;
  final int day;
  final int? hour;
  final int? minute;
  final int? second;

  final bool? starred;
  final String? feeling;

  @JsonKey(name: 'tags')
  final List<String>? _tags;
  final List<StoryContentDbModel> changes;

  @JsonKey(ignore: true)
  final List<String>? rawChanges;
  bool get useRawChanges => rawChanges?.isNotEmpty == true;

  DateTime get displayPathDate {
    return DateTime(
      year,
      month,
      day,
      hour ?? createdAt.hour,
      minute ?? createdAt.minute,
    );
  }

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? movedToBinAt;

  StoryDbModel({
    this.version = 1,
    required this.type,
    required this.id,
    required this.starred,
    required this.feeling,
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
    required this.changes,
    required this.updatedAt,
    required this.createdAt,
    List<String>? tags,
    this.movedToBinAt,
    this.rawChanges,
  }) : _tags = tags;

  factory StoryDbModel.fromJson(Map<String, dynamic> json) => _$StoryDbModelFromJson(json);

  @override
  Map<String, dynamic> toJson() {
    // remove dublicate
    Map<int, StoryContentDbModel> changes = {};
    for (final e in this.changes) changes[e.id] ??= e;
    return _$StoryDbModelToJson(copyWith(changes: changes.values.toList()));
  }

  List<String>? get tags {
    if (StoryTagsService.instance.tags.isNotEmpty) {
      final List<String> dbTags = StoryTagsService.instance.tags.map((e) => e.id.toString()).toList();
      return _tags?.where((element) => dbTags.contains(element)).toList();
    }
    return _tags;
  }

  bool get viewOnly => unarchivable || inBins;

  bool get inBins => type == PathType.bins;
  bool get editable => type == PathType.docs;
  bool get putBackAble => inBins || unarchivable;

  bool get archivable => type == PathType.docs;
  bool get unarchivable => type == PathType.archives;

  void addChange(StoryContentDbModel content) {
    changes.add(content);
  }

  factory StoryDbModel.fromNow() {
    final now = DateTime.now();
    return StoryDbModel.fromDate(now);
  }

  // use date for only path
  factory StoryDbModel.fromDate(DateTime date) {
    final now = DateTime.now();
    return StoryDbModel(
      year: date.year,
      month: date.month,
      day: date.day,
      hour: date.hour,
      minute: date.minute,
      second: date.second,
      type: PathType.docs,
      id: now.millisecondsSinceEpoch,
      starred: false,
      feeling: null,
      changes: [
        StoryContentDbModel.create(createdAt: now, id: now.millisecondsSinceEpoch),
      ],
      updatedAt: now,
      createdAt: now,
      tags: [],
    );
  }
}
