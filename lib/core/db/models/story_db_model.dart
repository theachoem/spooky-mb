import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
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

  final bool? starred;
  final String? feeling;

  final List<StoryContentDbModel> changes;

  final DateTime createdAt;
  final DateTime updatedAt;

  StoryDbModel({
    this.version = 1,
    required this.type,
    required this.id,
    required this.starred,
    required this.feeling,
    required this.year,
    required this.month,
    required this.day,
    required this.changes,
    required this.updatedAt,
    required this.createdAt,
  });

  @override
  Map<String, dynamic> toJson() => _$StoryDbModelToJson(this);
  factory StoryDbModel.fromJson(Map<String, dynamic> json) => _$StoryDbModelFromJson(json);

  bool get archived => type == PathType.archives;

  void removeChangeById(int id) {
    return changes.removeWhere((e) => e.id == id);
  }

  void removeChangeByIds(List<int> ids) {
    return changes.removeWhere((e) => ids.contains(e.id));
  }

  void addChange(StoryContentDbModel content) {
    removeChangeById(content.id);
    changes.add(content);
  }

  DateTime toDateTime() {
    return DateTime(year, month, day);
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
      type: PathType.docs,
      id: now.millisecondsSinceEpoch,
      starred: false,
      feeling: null,
      changes: [
        StoryContentDbModel.create(createdAt: now, id: now.millisecondsSinceEpoch),
      ],
      updatedAt: now,
      createdAt: now,
    );
  }
}
