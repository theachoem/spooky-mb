// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:spooky/core/databases/adapters/objectbox/story_box.dart';
import 'package:spooky/core/databases/models/base_db_model.dart';
import 'package:spooky/core/databases/models/story_content_db_model.dart';
import 'package:spooky/core/types/path_type.dart';

part 'story_db_model.g.dart';

@CopyWith()
@JsonSerializable()
class StoryDbModel extends BaseDbModel {
  static final StoryBox db = StoryBox();

  @override
  final int id;

  final int version;
  final PathType type;

  final int year;
  final int month;
  final int day;
  final int? hour;
  final int? minute;
  final int? second;

  final bool? starred;
  final String? feeling;

  // tags are mistaken stores in DB in string.
  // we use integer here, buts its actuals value is still in <string>.
  final List<int>? tags;

  final List<StoryContentDbModel> changes;

  @JsonKey(includeFromJson: true, includeToJson: true)
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
    required this.tags,
    required this.movedToBinAt,
    required this.rawChanges,
  });

  bool get viewOnly => unarchivable || inBins;

  bool get inBins => type == PathType.bins;
  bool get editable => type == PathType.docs;
  bool get putBackAble => inBins || unarchivable;

  bool get archivable => type == PathType.docs;
  bool get unarchivable => type == PathType.archives;

  int? get willBeRemovedInDays {
    if (movedToBinAt != null) {
      DateTime willBeRemovedAt = movedToBinAt!.add(const Duration(days: 30));
      return willBeRemovedAt.difference(DateTime.now()).inDays;
    }
    return null;
  }

  StoryDbModel copyWithNewChange(StoryContentDbModel newChange) {
    return copyWith(
      changes: [
        ...changes,
        newChange,
      ],
    );
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
        StoryContentDbModel.create(),
      ],
      updatedAt: now,
      createdAt: now,
      tags: [],
      movedToBinAt: null,
      rawChanges: null,
    );
  }

  Future<void> moveToBin() async {
    await db.set(copyWith(
      type: PathType.bins,
      movedToBinAt: DateTime.now(),
    ));
  }

  factory StoryDbModel.fromJson(Map<String, dynamic> json) => _$StoryDbModelFromJson(json);

  @override
  Map<String, dynamic> toJson() {
    // remove dublicate
    Map<int, StoryContentDbModel> changes = {};
    for (final e in this.changes) changes[e.id] ??= e;
    return _$StoryDbModelToJson(copyWith(changes: changes.values.toList()));
  }
}
