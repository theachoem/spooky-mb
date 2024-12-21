import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/databases/models/collection_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/databases/models/tag_db_model.dart';
import 'package:spooky/widgets/sp_default_text_controller.dart';
import 'package:spooky/widgets/sp_nested_navigation.dart';
import 'package:spooky/widgets/story_list/story_list.dart';

part 'local_widgets/tag_form.dart';

class TagsViewModel extends BaseViewModel {
  TagsViewModel() {
    load();
  }

  CollectionDbModel<TagDbModel>? tags;
  Map<int, int> storiesCountByTagId = {};
  int getStoriesCount(TagDbModel tag) => storiesCountByTagId[tag.id]!;

  Future<void> load() async {
    tags = await TagDbModel.db.where();
    storiesCountByTagId.clear();

    if (tags != null) {
      for (TagDbModel tag in tags?.items ?? []) {
        storiesCountByTagId[tag.id] = await StoryDbModel.db.count(filters: {'tag': tag.id});
      }
    }

    notifyListeners();
  }

  void viewTag(BuildContext context, TagDbModel tag) async {
    SpNestedNavigation.maybeOf(context)?.pushShareAxis(Scaffold(
      appBar: AppBar(title: Text(tag.title)),
      body: StoryList(tagId: tag.id),
    ));
  }

  Future<void> deleteTag(BuildContext context, TagDbModel tag) async {
    OkCancelResult result = await showOkCancelAlertDialog(
      context: context,
      title: "Are you sure to delete?",
      message: "You can't undo this action. Related stories will still remain",
    );

    if (result == OkCancelResult.ok) {
      await TagDbModel.db.delete(tag.id);
      await load();
    }
  }

  Future<void> editTag(BuildContext context, TagDbModel tag) async {
    dynamic result = await SpNestedNavigation.maybeOf(context)?.pushShareAxis(_TagForm(tags: tags, initialTag: tag));
    if (result is String) {
      TagDbModel newTag = tag.copyWith(title: result);
      await TagDbModel.db.set(newTag);
      await load();
    }
  }

  Future<void> addTag(BuildContext context) async {
    dynamic result = await SpNestedNavigation.maybeOf(context)?.pushShareAxis(_TagForm(tags: tags));
    if (result is String) {
      TagDbModel newTag = TagDbModel.fromNow().copyWith(title: result);
      await TagDbModel.db.set(newTag);
      await load();
    }
  }
}
