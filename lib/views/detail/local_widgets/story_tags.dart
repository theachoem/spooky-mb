import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:spooky/core/db/databases/tag_database.dart';
import 'package:spooky/core/db/models/tag_db_model.dart';
import 'package:spooky/theme/m3/m3_color.dart';
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

class _StoryTagsState extends State<StoryTags> with AutomaticKeepAliveClientMixin {
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
      ),
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
      body: object.copyWith(title: title, updatedAt: DateTime.now()),
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
      title: tr("alert.remove_tag.title"),
      message: tr("alert.remove_tag.message"),
      okLabel: tr("button.delete"),
      barrierDismissible: true,
      isDestructiveAction: true,
      cancelLabel: tr("button.cancel"),
    );

    if (result == OkCancelResult.ok) {
      await delete(object: object);
    }
  }

  Future<void> onReorder({
    required int oldIndex,
    required int newIndex,
  }) async {
    if (oldIndex < newIndex) newIndex -= 1;

    if (tags == null) return;
    if (newIndex > tags!.length - 1) return;
    if (oldIndex > tags!.length - 1) return;

    List<TagDbModel> tagsQueue = [...tags!];
    TagDbModel item = tagsQueue.removeAt(oldIndex);
    tagsQueue.insert(newIndex, item);

    setState(() {
      tags = List.generate(tagsQueue.length, (index) {
        return tagsQueue[index].copyWith(index: index);
      });
    });

    for (TagDbModel tag in tags!) {
      await tagDatabase.update(
        id: tag.id,
        body: tag,
      );
    }

    await load();
  }

  Future<void> onUpdate(BuildContext context, TagDbModel object) async {
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
      await update(
        object: object,
        title: title,
      );
    }
  }

  DialogTextField buildTagField(TagDbModel? object) {
    return DialogTextField(
      initialText: object?.title,
      hintText: tr("field.tags.hint_text"),
      validator: (String? title) {
        if (title == null || title.trim().isEmpty) {
          return tr("field.tags.must_not_empty");
        }

        final sames = tags?.where((element) => element.title.trim() == title.trim());
        if (sames?.isNotEmpty == true) {
          return tr("field.tags.already_exist", args: [title]);
        }

        return null;
      },
    );
  }

  Future<void> onCreate(BuildContext context) async {
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
    super.build(context);
    return Column(
      children: [
        if (tags != null)
          ReorderableListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: tags?.length ?? 0,
            onReorder: (int oldIndex, int newIndex) {
              onReorder(oldIndex: oldIndex, newIndex: newIndex);
            },
            itemBuilder: (context, index) {
              TagDbModel object = tags![index];
              return buildTagTile(context, object);
            },
          ),
        ListTile(
          title: Text(tr("button.add")),
          leading: const Icon(Icons.add),
          onTap: () async {
            await onCreate(context);
          },
        ),
      ],
    );
  }

  Widget buildTagTile(BuildContext context, TagDbModel object) {
    return ClipRRect(
      key: ValueKey(object.id),
      clipBehavior: Clip.hardEdge,
      child: Slidable(
        key: ValueKey(object.id),
        endActionPane: buildActionsPane(context, object),
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
      ),
    );
  }

  ActionPane buildActionsPane(
    BuildContext context,
    TagDbModel object,
  ) {
    return ActionPane(
      motion: const StretchMotion(),
      dismissible: null,
      extentRatio: 0.5,
      children: [
        SlidableAction(
          backgroundColor: M3Color.of(context).error,
          foregroundColor: M3Color.of(context).onError,
          onPressed: (_) => onDelete(context, object),
          icon: Icons.delete,
          label: null,
        ),
        SlidableAction(
          backgroundColor: M3Color.of(context).primary,
          foregroundColor: M3Color.of(context).onPrimary,
          icon: Icons.edit,
          label: null,
          onPressed: (_) => onUpdate(context, object),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
