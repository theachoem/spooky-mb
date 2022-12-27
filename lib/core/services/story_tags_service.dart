// ignore_for_file: use_build_context_synchronously

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

  Future<void> load() async {
    _tags = await tagDatabase.fetchAll().then((value) => value?.items ?? []);
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
      await tagDatabase.update(
        id: object.id,
        body: object.copyWith(title: title, updatedAt: DateTime.now()),
      );
      await load();
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
    required BuildContext context,
  }) async {
    if (oldIndex < newIndex) newIndex -= 1;

    if (newIndex > tags.length - 1) return;
    if (oldIndex > tags.length - 1) return;

    List<TagDbModel> tagsQueue = [...tags];
    TagDbModel item = tagsQueue.removeAt(oldIndex);
    tagsQueue.insert(newIndex, item);

    _tags = beforeSave(List.generate(tagsQueue.length, (index) {
      return tagsQueue[index].copyWith(index: index);
    }));

    for (TagDbModel tag in tags) {
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
