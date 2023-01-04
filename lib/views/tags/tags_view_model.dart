import 'package:flutter/material.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/db/models/tag_db_model.dart';
import 'package:spooky/core/services/story_tags_service.dart';

class TagsViewModel extends BaseViewModel {
  late List<TagDbModel> _tags;
  List<TagDbModel> get tags => _tags;

  TagsViewModel() {
    _tags = StoryTagsService.instance.tags;
  }

  Future<void> toggleStarred(TagDbModel tag) async {
    return StoryTagsService.instance.dbUpdate(
      tag.copyWith(starred: !(tag.starred == true)),
      beforeSave: (tags) {
        _tags = tags;
        notifyListeners();
        return _tags;
      },
    );
  }

  Future<void> reorder(int oldIndex, int newIndex) {
    return StoryTagsService.instance.reorder(
      oldIndex: oldIndex,
      newIndex: newIndex,
      beforeSave: (List<TagDbModel> tags) {
        _tags = tags;
        notifyListeners();
        return _tags;
      },
    );
  }

  Future<void> delete(TagDbModel object, BuildContext context) async {
    await StoryTagsService.instance.delete(context, object);
    _tags = StoryTagsService.instance.tags;
    notifyListeners();
  }

  Future<void> update(TagDbModel object, BuildContext context) async {
    await StoryTagsService.instance.update(context, object);
    _tags = StoryTagsService.instance.tags;
    notifyListeners();
  }

  Future<void> create(BuildContext context) async {
    await StoryTagsService.instance.create(context);
    _tags = StoryTagsService.instance.tags;
    notifyListeners();
  }
}
