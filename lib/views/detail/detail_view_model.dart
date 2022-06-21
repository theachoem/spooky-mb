import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/story_writers/auto_save_story_writer.dart';
import 'package:spooky/core/story_writers/default_story_writer.dart';
import 'package:spooky/core/story_writers/delete_change_writer.dart';
import 'package:spooky/core/story_writers/objects/auto_save_story_object.dart';
import 'package:spooky/core/story_writers/objects/default_story_object.dart';
import 'package:spooky/core/story_writers/objects/delete_change_object.dart';
import 'package:spooky/core/story_writers/objects/restore_story_object.dart';
import 'package:spooky/core/story_writers/objects/update_page_object.dart';
import 'package:spooky/core/story_writers/restore_story_writer.dart';
import 'package:spooky/views/detail/detail_view_model_getter.dart';
import 'package:spooky/utils/helpers/story_writer_helper.dart';
import 'package:spooky/core/story_writers/update_page_writer.dart';
import 'package:spooky/core/services/initial_tab_service.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/views/detail/local_mixins/detail_view_model_ui_mixin.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';
import 'package:spooky/core/base/base_view_model.dart';

class DetailViewModel extends BaseViewModel with ScheduleMixin, WidgetsBindingObserver, DetailViewModelUiMixin {
  late StoryDbModel currentStory;
  late DetailViewFlowType flowType;
  late StoryContentDbModel currentContent;

  DetailViewModelGetter get info {
    return DetailViewModelGetter(
      currentStory: currentStory,
      flowType: flowType,
      currentContent: currentContent,
      title: titleController.text,
      hasChange: hasChangeNotifer.value,
      quillControllers: quillControllers,
      openOn: openOn,
    );
  }

  DetailViewModel({
    required this.currentStory,
    required this.flowType,
  }) {
    currentContent = initialContent(currentStory);
    initMixinState(flowType, currentContent);
    WidgetsBinding.instance.addObserver(this);
    setListener();
  }

  Future<void> loadHasChange() async {
    bool hasChange = await _fetchHasChange();
    hasChangeNotifer.value = hasChange;
  }

  Future<bool> _fetchHasChange() async {
    if (currentStory.changes.isEmpty) return true;
    StoryContentDbModel content = await StoryWriteHelper.buildContent(
      currentContent,
      quillControllers,
      titleController.text,
      openOn,
    );
    return content.hasChanges(currentStory.changes.last);
  }

  void onChange(Document _) {
    scheduleAction(() {
      loadHasChange();
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

  void saveStates(StoryDbModel story) {
    flowType = DetailViewFlowType.update;
    currentStory = story;
    currentContent = story.changes.last;
    loadHasChange();
    notifyListeners();
  }

  // if user close app, we store initial tab on home
  // so they new it is saved.
  Future<void> autosave() async {
    if (!hasChangeNotifer.value) return;
    InitialStoryTabService.setInitialTab(currentStory.year, currentStory.month);
    AutoSaveStoryWriter writer = AutoSaveStoryWriter();
    StoryDbModel? story = await writer.save(AutoSaveStoryObject(info));
    if (story != null) saveStates(story);
  }

  Future<void> save() async {
    DefaultStoryWriter writer = DefaultStoryWriter();
    StoryDbModel? story = await writer.save(DefaultStoryObject(info));
    if (story != null) saveStates(story);
  }

  Future<StoryDbModel> deleteChange(List<int> contentIds) async {
    DeleteChangeWriter writer = DeleteChangeWriter();
    StoryDbModel? story = await writer.save(DeleteChangeObject(info, contentIds: contentIds));
    if (story != null) saveStates(story);
    return currentStory;
  }

  /// restore and updatePages will be push replace to same screen instead.
  /// so, no need to saveStates(story)
  Future<void> restore(int contentId) async {
    RestoreStoryWriter writer = RestoreStoryWriter();
    await writer.save(RestoreStoryObject(info, contentId: contentId));
  }

  Future<void> updatePages(StoryContentDbModel value) async {
    UpdatePageWriter writer = UpdatePageWriter();
    await writer.save(UpdatePageObject(info, pages: value.pages));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    List<AppLifecycleState> shouldSaveInStates = [AppLifecycleState.paused, AppLifecycleState.inactive];
    if (shouldSaveInStates.contains(state)) autosave();
    if (state == AppLifecycleState.resumed) loadHasChange();
    super.didChangeAppLifecycleState(state);
  }

  @mustCallSuper
  void setListener() {
    readOnlyNotifier.addListener(() {
      readOnlyNotifier.value ? currentFocusNode?.unfocus() : loadHasChange();
      toolbarVisibleNotifier.value = !readOnlyNotifier.value;
    });

    titleController.addListener(() {
      scheduleAction(() {
        loadHasChange();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
