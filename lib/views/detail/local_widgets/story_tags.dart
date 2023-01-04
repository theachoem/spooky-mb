import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:spooky/core/db/models/tag_db_model.dart';
import 'package:spooky/core/services/story_tags_service.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_sections_tiles.dart';

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

class _StoryTagsState extends State<StoryTags> with ScheduleMixin {
  late final ValueNotifier<List<int>> selectedTagsIdNotifiers;
  List<TagDbModel>? tags;

  @override
  void initState() {
    super.initState();
    selectedTagsIdNotifiers = ValueNotifier<List<int>>([]);
    load(false);
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
    scheduleAction(() {
      widget.onUpdated(selectedTagsIdNotifiers.value);
    });
  }

  void load([bool updateState = true]) {
    tags = StoryTagsService.instance.tags;
    if (updateState) setState(() {});
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
    return ListView(
      children: SpSectionsTiles.divide(
        context: context,
        sections: [
          SpSectionContents(
            headline: tr("section.tags"),
            leadingIcon: CommunityMaterialIcons.tag,
            actionButton: SpIconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await StoryTagsService.instance.create(context);
                load();
              },
            ),
            tiles: [
              const Divider(height: 1),
              if (tags != null) buildStoryTags(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildStoryTags() {
    return ReorderableListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: tags?.length ?? 0,
      onReorder: (int oldIndex, int newIndex) async {
        await StoryTagsService.instance.reorder(
          oldIndex: oldIndex,
          newIndex: newIndex,
          beforeSave: (List<TagDbModel> tags) {
            setState(() => this.tags = tags);
            return tags;
          },
        );

        load();
      },
      itemBuilder: (context, index) {
        TagDbModel object = tags![index];
        return buildTagTile(context, object);
      },
    );
  }

  Widget buildTagTile(BuildContext context, TagDbModel object) {
    return Slidable(
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
          icon: Icons.delete,
          label: null,
          onPressed: (_) async {
            await StoryTagsService.instance.delete(context, object);
            load();
          },
        ),
        SlidableAction(
          backgroundColor: M3Color.of(context).primary,
          foregroundColor: M3Color.of(context).onPrimary,
          icon: Icons.edit,
          label: null,
          onPressed: (_) async {
            await StoryTagsService.instance.update(context, object);
            load();
          },
        ),
      ],
    );
  }
}
