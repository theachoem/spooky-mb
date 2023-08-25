import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/models/story_config_model.dart';
import 'package:spooky/core/storages/local_storages/story_config_storage.dart';
import 'package:spooky/core/types/sort_type.dart';
import 'package:spooky/widgets/sp_story_list/sp_story_list.dart';

/// For single source of information,
/// Let READ data from [storage.currentObject] instead.
class StoryConfigProvider extends ChangeNotifier {
  final StoryConfigStorage storage = StoryConfigStorage.instance;

  late final ValueNotifier<bool?> prioritiedNotifier;
  late final ValueNotifier<bool?> disableDatePickerNotifier;
  late final ValueNotifier<SortType?> sortTypeNotifier;
  late final ValueNotifier<SpListLayoutType?> layoutTypeNotifier;

  StoryConfigProvider() {
    prioritiedNotifier = ValueNotifier(null);
    disableDatePickerNotifier = ValueNotifier(null);
    sortTypeNotifier = ValueNotifier(null);
    layoutTypeNotifier = ValueNotifier(null);

    load();
  }

  @override
  void dispose() {
    prioritiedNotifier.dispose();
    disableDatePickerNotifier.dispose();
    sortTypeNotifier.dispose();
    layoutTypeNotifier.dispose();
    super.dispose();
  }

  Future<void> load() async {
    StoryConfigModel? object = await storage.readObject();
    prioritiedNotifier.value = object?.prioritied ?? true;
    disableDatePickerNotifier.value = object?.disableDatePicker;
    sortTypeNotifier.value = object?.sortType;
    layoutTypeNotifier.value = object?.layoutType ?? storage.layoutType;
  }

  Future<void> setPriorityStarred(bool value) async {
    if (value == prioritiedNotifier.value) return;
    await storage.writeObject(storage.currentObject.copyWith(prioritied: value));
    await load();
  }

  Future<void> setDisableDatePicker(bool value) async {
    if (value == disableDatePickerNotifier.value) return;
    await storage.writeObject(storage.currentObject.copyWith(disableDatePicker: value));
    await load();
  }

  Future<void> setSortType(SortType value) async {
    if (value == sortTypeNotifier.value) return;
    await storage.writeObject(storage.currentObject.copyWith(sortType: value));
    await load();
  }

  // Layout type need to reload both app bar and body,
  // so we should restart app on updated
  Future<void> setLayoutType(SpListLayoutType value) async {
    if (value == storage.layoutType) return;
    await storage.writeObject(storage.currentObject.copyWith(layoutType: value));
  }

  Future<SortType?> showSortSelectorDialog(BuildContext context, [SortType? initialSortType]) async {
    return showConfirmationDialog(
      context: context,
      title: tr("tile.sort.title"),
      initialSelectedActionKey: initialSortType ?? storage.sortType,
      cancelLabel: MaterialLocalizations.of(context).cancelButtonLabel,
      actions: [
        AlertDialogAction(
          key: SortType.newToOld,
          label: SortType.newToOld.title,
        ),
        AlertDialogAction(
          key: SortType.oldToNew,
          label: SortType.oldToNew.title,
        ),
      ].map((e) {
        return AlertDialogAction<SortType>(
          key: e.key,
          isDefaultAction: e.key == storage.sortType,
          label: e.label,
        );
      }).toList(),
    );
  }
}
