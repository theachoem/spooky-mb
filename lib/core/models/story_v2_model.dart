import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/core/models/story_content_v2_model.dart';
import 'package:spooky/core/types/file_path_type.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:spooky/core/types/path_type.dart';

part 'story_v2_model.g.dart';

@CopyWith()
@JsonSerializable()
class StoryV2Model extends BaseModel {
  final PathType type;
  final int id;

  final int year;
  final int month;
  final int day;

  final bool? starred;
  final String? feeling;

  final List<StoryContentV2Model> changes;

  StoryV2Model({
    required this.type,
    required this.id,
    required this.starred,
    required this.feeling,
    required this.year,
    required this.month,
    required this.day,
    required this.changes,
  });

  factory StoryV2Model.fromNow() {
    final now = DateTime.now();
    return StoryV2Model.fromDate(now);
  }

  // use date for only path
  factory StoryV2Model.fromDate(DateTime date) {
    final now = DateTime.now();
    return StoryV2Model(
      type: PathType.docs,
      id: now.millisecondsSinceEpoch,
      day: date.day,
      month: date.month,
      year: date.year,
      feeling: null,
      starred: null,
      changes: [
        StoryContentV2Model.create(createdAt: now, id: now.millisecondsSinceEpoch),
      ],
    );
  }

  bool get archived {
    return type == FilePathType.archive;
  }

  void removeChangeById(int id) {
    return changes.removeWhere((e) => e.id == id);
  }

  void removeChangeByIds(List<int> ids) {
    return changes.removeWhere((e) => ids.contains(e.id));
  }

  void addChange(StoryContentV2Model content) {
    removeChangeById(content.id);
    changes.add(content);
  }

  @override
  Map<String, dynamic> toJson() => _$StoryV2ModelToJson(this);
  factory StoryV2Model.fromJson(Map<String, dynamic> json) => _$StoryV2ModelFromJson(json);

  @override
  String? get objectId => id.toString();
}
