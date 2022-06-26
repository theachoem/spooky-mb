import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/db/databases/tag_database.dart';
import 'package:spooky/core/db/models/tag_db_model.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';

class StoryTags extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  StoryTags({
    Key? key,
    required this.selectedTagsIds,
    required this.onUpdated,
  }) : super(key: key);

  final List<String> selectedTagsIds;
  final void Function(List<int> ids) onUpdated;

  @override
  State<StoryTags> createState() => _StoryTagsState();
}

class _StoryTagsState extends State<StoryTags> {
  final TagDatabase tagDatabase = TagDatabase.instance;
  late final ValueNotifier<List<int>> selectedTagsIdNotifiers;
  List<TagDbModel>? tags;

  @override
  void initState() {
    super.initState();
    selectedTagsIdNotifiers = ValueNotifier<List<int>>([]);
    load().then((value) => loadSelected());
  }

  void loadSelected() async {
    List<int> selectedTagsIds = [];
    for (String id in widget.selectedTagsIds) {
      int? validatedId = int.tryParse(id);
      if (validatedId != null) selectedTagsIds.add(validatedId);
    }

    Iterable<int> tagIds = tags?.map((e) => e.id) ?? [];
    selectedTagsIds.removeWhere((id) => !tagIds.contains(id));

    selectedTagsIdNotifiers.value = selectedTagsIds;
  }

  void setSelected(int id, bool selected) {
    Set<int> selectedTagsIds = {...selectedTagsIdNotifiers.value.toSet()};
    if (selected) {
      selectedTagsIds.add(id);
    } else {
      selectedTagsIds.remove(id);
    }
    selectedTagsIdNotifiers.value = selectedTagsIds.toList();
    widget.onUpdated(selectedTagsIdNotifiers.value);
  }

  Future<void> load() async {
    final result = await tagDatabase.fetchAll();
    setState(() {
      tags = result?.items ?? [];
    });
  }

  // make sure to validate before call
  Future<void> create(String title) async {
    await tagDatabase.create(
      body: TagDbModel(
        id: 0,
        createdAt: DateTime.now(),
        emoji: null,
        starred: null,
        title: title.trim(),
        updatedAt: DateTime.now(),
        version: 0,
      ).toJson(),
    );
    await load();
  }

  // make sure to validate before call
  Future<void> update({
    required String title,
    required TagDbModel object,
  }) async {
    await tagDatabase.update(
      id: object.id,
      body: object.copyWith(title: title, updatedAt: DateTime.now()).toJson(),
    );
    await load();
  }

  Future<void> delete({
    required TagDbModel object,
  }) async {
    await tagDatabase.delete(id: object.id);
    await load();
  }

  Future<void> onDelete(BuildContext context, TagDbModel object) async {
    OkCancelResult result = await showOkCancelAlertDialog(
      context: context,
      title: "Are you sure to delete tag?",
      message: "This tags will be deleted globally, you can't undo this action",
      okLabel: "Delete",
      isDestructiveAction: true,
    );

    if (result == OkCancelResult.ok) {
      await delete(object: object);
    }
  }

  Future<void> onUpdate(BuildContext context, TagDbModel object) async {
    List<String>? result = await showTextInputDialog(
      context: context,
      title: "Update tag",
      textFields: [
        DialogTextField(
          initialText: object.title,
          hintText: "Tags",
          validator: (String? title) {
            if (title == null || title.trim().isEmpty) {
              return "Must not empty";
            }

            final sames = tags?.where((element) => element.title.trim() == title.trim());
            if (sames?.isNotEmpty == true) {
              return "$title already exist";
            }

            return null;
          },
        ),
      ],
    );

    if (result != null) {
      String title = result[0];
      await update(
        object: object,
        title: title,
      );
    }
  }

  Future<void> onCreate(BuildContext context) async {
    List<String>? result = await showTextInputDialog(
      context: context,
      title: "Enter tag",
      textFields: [
        DialogTextField(
          hintText: "Tags",
          validator: (String? title) {
            if (title == null || title.trim().isEmpty) {
              return "Must not empty";
            }

            final sames = tags?.where((element) => element.title.trim() == title.trim());
            if (sames?.isNotEmpty == true) {
              return "$title already exist";
            }

            return null;
          },
        ),
      ],
    );

    if (result != null) {
      String title = result[0];
      await create(title);
    }
  }

  @override
  void didUpdateWidget(covariant StoryTags oldWidget) {
    loadSelected();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    loadSelected();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...tags?.map((object) {
              return buildTagTile(context, object);
            }) ??
            [],
        ListTile(
          title: const Text("Add"),
          leading: const Icon(Icons.add),
          onTap: () async {
            await onCreate(context);
          },
        ),
      ],
    );
  }

  Widget buildTagTile(BuildContext context, TagDbModel object) {
    return GestureDetector(
      onLongPress: () async {
        String? option = await showModalActionSheet(context: context, actions: [
          const SheetAction(label: "Update", key: "update"),
          const SheetAction(label: "Delete", key: "delete", isDestructiveAction: true),
        ]);

        switch (option) {
          case "update":
            // ignore: use_build_context_synchronously
            onUpdate(context, object);
            break;
          case "delete":
            // ignore: use_build_context_synchronously
            onDelete(context, object);
            break;
        }
      },
      child: ValueListenableBuilder<List<int>>(
        valueListenable: selectedTagsIdNotifiers,
        builder: (context, selectedIds, child) {
          return CheckboxListTile(
            value: selectedIds.contains(object.id),
            title: Text(object.title),
            subtitle: Text(DateFormatHelper.dateTimeFormat().format(object.createdAt)),
            onChanged: (value) => setSelected(object.id, value == true),
          );
        },
      ),
    );
  }
}
