import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/db/databases/tag_database.dart';
import 'package:spooky/core/db/models/tag_db_model.dart';

class StoryTagsService {
  StoryTagsService._();
  static final instance = StoryTagsService._();

  final TagDatabase tagDatabase = TagDatabase.instance;
  List<TagDbModel>? _tags;
  List<TagDbModel> get tags => _tags ?? [];
  List<TagDbModel> get displayTags => (_tags ?? []).where((element) => element.starred == true).toList();

  Future<void> load() async {
    _tags = await tagDatabase.fetchAll().then((value) => value?.items ?? []);
  }

  Future<void> dbUpdate(
    TagDbModel object, {
    List<TagDbModel> Function(List<TagDbModel> tags)? beforeSave,
  }) async {
    int index = tags.lastIndexWhere((element) => element.id == object.id);

    if (beforeSave != null) {
      _tags ??= [];
      _tags![min(index, _tags!.length)] = object;
      beforeSave(_tags!);
    }

    await tagDatabase.update(id: object.id, body: object.copyWith(updatedAt: DateTime.now()));
    await load();
  }

  Future<void> delete(BuildContext context, TagDbModel object) async {
    OkCancelResult result = await showOkCancelAlertDialog(
      context: context,
      title: tr("alert.remove_tag.title"),
      message: tr("alert.remove_tag.message"),
      okLabel: tr("button.delete"),
      barrierDismissible: true,
      isDestructiveAction: true,
      cancelLabel: tr("button.cancel"),
    );

    if (result == OkCancelResult.ok) {
      await tagDatabase.delete(id: object.id);
      await load();
    }
  }

  Future<void> update(BuildContext context, TagDbModel object) async {
    List<String>? result = await showTextInputDialog(
      context: context,
      title: tr("alert.update_tag.title"),
      barrierDismissible: true,
      okLabel: tr("button.ok"),
      cancelLabel: tr("button.cancel"),
      textFields: [
        buildTagField(object),
      ],
    );

    if (result != null) {
      String title = result[0];
      await dbUpdate(object.copyWith(title: title));
    }
  }

  Future<void> create(BuildContext context) async {
    List<String>? result = await showTextInputDialog(
      context: context,
      title: tr("alert.create_tag.title"),
      okLabel: tr("button.ok"),
      cancelLabel: tr("button.cancel"),
      textFields: [
        buildTagField(null),
      ],
    );

    if (result != null) {
      String title = result[0];
      await tagDatabase.create(
        body: TagDbModel(
          id: 0,
          createdAt: DateTime.now(),
          emoji: null,
          starred: null,
          title: title.trim(),
          updatedAt: DateTime.now(),
          version: 0,
        ),
      );
      await load();
    }
  }

  Future<void> reorder({
    required int oldIndex,
    required int newIndex,
    required List<TagDbModel> Function(List<TagDbModel> tags) beforeSave,
    bool displayTag = false,
  }) async {
    if (oldIndex < newIndex) newIndex -= 1;
    List<TagDbModel>? newTags;

    // if display tags, caculate new value index for [oldIndex & newIndex]
    if (displayTag) {
      if (newIndex > displayTags.length - 1) return;
      if (oldIndex > displayTags.length - 1) return;

      oldIndex = tags.lastIndexWhere((e) => e.id == displayTags[oldIndex].id);
      newIndex = tags.lastIndexWhere((e) => e.id == displayTags[newIndex].id);

      List<TagDbModel> tagsQueue = [...tags];
      TagDbModel item = tagsQueue.removeAt(oldIndex);
      tagsQueue.insert(newIndex, item);

      newTags = beforeSave(List.generate(tagsQueue.length, (index) {
        return tagsQueue[index].copyWith(index: index);
      }).where((element) => element.starred == true).toList());
    } else {
      if (newIndex > tags.length - 1) return;
      if (oldIndex > tags.length - 1) return;

      List<TagDbModel> tagsQueue = [...tags];
      TagDbModel item = tagsQueue.removeAt(oldIndex);
      tagsQueue.insert(newIndex, item);

      newTags = beforeSave(List.generate(tagsQueue.length, (index) {
        return tagsQueue[index].copyWith(index: index);
      }));
    }

    for (TagDbModel tag in newTags) {
      await StoryTagsService.instance.tagDatabase.update(
        id: tag.id,
        body: tag,
      );
    }

    await load();
  }

  DialogTextField buildTagField(TagDbModel? object) {
    return DialogTextField(
      initialText: object?.title,
      hintText: tr("field.tags.hint_text"),
      validator: (String? title) {
        if (title == null || title.trim().isEmpty) {
          return tr("field.tags.must_not_empty");
        }

        final sames = tags.where((element) => element.title.trim() == title.trim());
        if (sames.isNotEmpty == true) {
          return tr("field.tags.already_exist", args: [title]);
        }

        return null;
      },
    );
  }
}
