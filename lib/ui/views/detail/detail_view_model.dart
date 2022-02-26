import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/file_manager/story_writers/auto_save_story_writer.dart';
import 'package:spooky/core/file_manager/story_writers/default_story_writer.dart';
import 'package:spooky/core/file_manager/story_writers/delete_change_writer.dart';
import 'package:spooky/core/file_manager/story_writers/objects/auto_save_story_object.dart';
import 'package:spooky/core/file_manager/story_writers/objects/default_story_object.dart';
import 'package:spooky/core/file_manager/story_writers/objects/delete_change_object.dart';
import 'package:spooky/core/file_manager/story_writers/objects/restore_story_object.dart';
import 'package:spooky/core/file_manager/story_writers/objects/update_page_object.dart';
import 'package:spooky/core/file_manager/story_writers/restore_story_writer.dart';
import 'package:spooky/core/file_manager/story_writers/update_page_writer.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/services/initial_tab_service.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/ui/views/detail/local_mixins/detail_view_model_ui_mixin.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';
import 'package:stacked/stacked.dart';

class DetailViewModel extends BaseViewModel with ScheduleMixin, WidgetsBindingObserver, DetailViewModelUiMixin {
  late StoryModel currentStory;
  late DetailViewFlowType flowType;
  late StoryContentModel currentContent;

  DetailViewModel({
    required this.currentStory,
    required this.flowType,
  }) {
    currentContent = initialContent(currentStory);
    initMixinState(flowType, currentContent);
    WidgetsBinding.instance?.addObserver(this);
    _setListener();
  }

  bool get hasChange {
    if (currentStory.changes.isEmpty) return true;
    return DefaultStoryWriter()
        .buildContent(currentContent, quillControllers, titleController, openOn)
        .hasChanges(currentStory.changes.last);
  }

  void onChange(Document _) {
    scheduleAction(() {
      hasChangeNotifer.value = hasChange;
    });
  }

  void addPage() {
    currentContent.addPage();
    notifyListeners();
    Future.delayed(ConfigConstant.fadeDuration).then((value) {
      pageController.animateToPage(
        currentContent.pages!.length - 1,
        duration: ConfigConstant.duration,
        curve: Curves.ease,
      );
    });
  }

  // if user close app, we store initial tab on home
  // so they new it is saved.
  Future<void> autosave() async {
    InitialStoryTabService.setInitialTab(currentStory.path.year, currentStory.path.month);
    AutoSaveStoryWriter writer = AutoSaveStoryWriter();
    StoryModel? writenStory = await writer.save(AutoSaveStoryObject(this));
    if (writenStory != null) hasAutosaved = true;
  }

  Future<void> save() async {
    DefaultStoryWriter writer = DefaultStoryWriter();
    StoryModel? story = await writer.save(DefaultStoryObject(this));
    if (story != null) {
      flowType = DetailViewFlowType.update;
      notifyListeners();
    }
  }

  Future<void> deleteChange(List<String> contentIds) async {
    DeleteChangeWriter writer = DeleteChangeWriter();
    StoryModel? story = await writer.save(DeleteChangeObject(this, contentIds: contentIds));
    if (story != null) {
      flowType = DetailViewFlowType.update;
      notifyListeners();
    }
  }

  Future<void> restore(String contentId) async {
    RestoreStoryWriter writer = RestoreStoryWriter();
    await writer.save(RestoreStoryObject(this, contentId: contentId));
  }

  Future<void> updatePages(StoryContentModel value) async {
    UpdatePageWriter writer = UpdatePageWriter();
    await writer.save(UpdatePageObject(this, pages: value.pages));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    List<AppLifecycleState> shouldSaveInStates = [AppLifecycleState.paused, AppLifecycleState.inactive];

    bool shouldAutoSave = shouldSaveInStates.contains(state);
    if (shouldAutoSave) autosave();

    bool shouldSetHasChange = state == AppLifecycleState.resumed && hasAutosaved;
    if (shouldSetHasChange) {
      hasAutosaved = false;
      hasChangeNotifer.value = hasChange;
    }

    super.didChangeAppLifecycleState(state);
  }

  void _setListener() {
    readOnlyNotifier.addListener(() {
      readOnlyNotifier.value ? currentFocusNode?.unfocus() : hasChangeNotifer.value = hasChange;
      toolbarVisibleNotifier.value = !readOnlyNotifier.value;
    });
    titleController.addListener(() {
      scheduleAction(() {
        hasChangeNotifer.value = hasChange;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }
}
