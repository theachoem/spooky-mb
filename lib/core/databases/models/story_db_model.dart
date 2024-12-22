// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter_quill/quill_delta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:spooky/core/databases/adapters/objectbox/story_box.dart';
import 'package:spooky/core/databases/models/base_db_model.dart';
import 'package:spooky/core/databases/models/story_content_db_model.dart';
import 'package:spooky/core/services/story_db_constructor_service.dart';
import 'package:spooky/core/services/story_helper.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/views/stories/edit/edit_story_view_model.dart';

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
  final StoryContentDbModel? latestChange;

  /// load this manually when needed with [loadAllChanges]
  final List<StoryContentDbModel>? allChanges;

  final List<String>? rawChanges;

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
    required this.latestChange,
    required this.allChanges,
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

  factory StoryDbModel.fromNow() {
    final now = DateTime.now();
    return StoryDbModel.fromDate(now);
  }

  // use date for only path
  factory StoryDbModel.fromDate(
    DateTime date, {
    int? initialYear,
  }) {
    final now = DateTime.now();
    return StoryDbModel(
      year: initialYear ?? date.year,
      month: date.month,
      day: date.day,
      hour: date.hour,
      minute: date.minute,
      second: date.second,
      type: PathType.docs,
      id: now.millisecondsSinceEpoch,
      starred: false,
      feeling: null,
      latestChange: StoryContentDbModel.create(),
      allChanges: null,
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
      updatedAt: DateTime.now(),
      movedToBinAt: DateTime.now(),
    ));
  }

  static Future<StoryDbModel> fromDetailPage(EditStoryViewModel viewModel) async {
    StoryContentDbModel content = await StoryHelper.buildContent(
      viewModel.draftContent!,
      viewModel.quillControllers,
    );

    return viewModel.story!.copyWith(
      updatedAt: DateTime.now(),
      latestChange: content,
    );
  }

  factory StoryDbModel.startYearStory(int year) {
    StoryDbModel initialStory = StoryDbModel.fromDate(DateTime(year, 1, 1));
    String body =
        "This is your personal space for $year. Add your stories, thoughts, dreams, or memories and make it uniquely yours.\n";
    Delta delta = Delta()..insert(body);

    initialStory = initialStory.copyWith(
      latestChange: initialStory.latestChange!.copyWith(
        title: "Let's Begin: $year ✨",
        pages: [delta.toJson()],
        plainText: body,
      ),
    );

    return initialStory;
  }

  Future<StoryDbModel> loadAllChanges() async {
    return StoryDbConstructorService.loadAllChanges(this);
  }

  factory StoryDbModel.fromJson(Map<String, dynamic> json) => _$StoryDbModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StoryDbModelToJson(this);
}
