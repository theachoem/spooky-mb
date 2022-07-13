import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/story_writers/auto_save_story_writer.dart';
import 'package:spooky/core/story_writers/default_story_writer.dart';
import 'package:spooky/core/story_writers/delete_change_writer.dart';
import 'package:spooky/core/story_writers/draft_story_writer.dart';
import 'package:spooky/core/story_writers/objects/default_story_object.dart';
import 'package:spooky/core/story_writers/objects/delete_change_object.dart';
import 'package:spooky/core/story_writers/objects/draft_story_object.dart';
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

  Future<DetailViewModelGetter> get info async {
    await loadHasChange();
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
    if (currentStory.changes.isEmpty) return false;

    if (currentStory.changes.length == 1 && flowType == DetailViewFlowType.create) {
      StoryContentDbModel content = await buildContent();
      return content.hasDataWritten(content);
    }

    StoryContentDbModel content = await buildContent();
    return content.hasChanges(currentStory.changes.last);
  }

  Future<StoryContentDbModel> buildContent() async {
    StoryContentDbModel content = await StoryWriteHelper.buildContent(
      currentContent,
      quillControllers,
      titleController.text,
      openOn,
    );
    return content;
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
  //
  // This consider as draft.
  Future<void> autosave() async {
    if (!hasChangeNotifer.value) return;
    InitialStoryTabService.setInitialTab(currentStory.year, currentStory.month);
    AutoSaveStoryWriter writer = AutoSaveStoryWriter();
    StoryDbModel? story = await writer.save(DraftStoryObject(await info));
    if (story != null) saveStates(story);
  }

  Future<void> saveDraft(BuildContext context) async {
    if (!hasChangeNotifer.value) return;
    InitialStoryTabService.setInitialTab(currentStory.year, currentStory.month);
    DraftStoryWriter writer = DraftStoryWriter();

    StoryDbModel? story = await MessengerService.instance.showLoading(
      future: () async => writer.save(DraftStoryObject(await info)),
      context: context,
      debugSource: "DetailView#onWillPop",
    );

    if (story != null) saveStates(story);
  }

  Future<void> save(BuildContext context) async {
    DefaultStoryWriter writer = DefaultStoryWriter();

    StoryDbModel? story = await MessengerService.instance.showLoading(
      future: () async => writer.save(DefaultStoryObject(await info)),
      context: context,
      debugSource: "DetailViewModel#save",
    );

    if (story != null) saveStates(story);
  }

  Future<StoryDbModel> deleteChange(List<int> contentIds) async {
    DeleteChangeWriter writer = DeleteChangeWriter();
    StoryDbModel? story = await writer.save(DeleteChangeObject(await info, contentIds: contentIds));
    if (story != null) saveStates(story);
    return currentStory;
  }

  /// restore and updatePages will be push replace to same screen instead.
  /// so, no need to saveStates(story)
  Future<void> restore(int contentId) async {
    RestoreStoryWriter writer = RestoreStoryWriter();
    await writer.save(RestoreStoryObject(await info, contentId: contentId));
  }

  Future<void> updatePages(StoryContentDbModel value) async {
    UpdatePageWriter writer = UpdatePageWriter();
    await writer.save(UpdatePageObject(await info, pages: value.pages));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    List<AppLifecycleState> shouldSaveInStates = [
      AppLifecycleState.inactive,
    ];

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

  // ==============================
  // METHOD that set to db directly
  // ==============================

  Future<StoryDbModel> setTagIds(List<int> ids) async {
    StoryDbModel? story =
        await StoryDatabase.instance.set(body: currentStory.copyWith(tags: ids.map((e) => e.toString()).toList()));
    if (story != null) currentStory = story;
    return currentStory;
  }

  Future<StoryDbModel> setPathDate(DateTime pathDate) async {
    StoryDbModel? story = await StoryDatabase.instance.set(
      body: currentStory.copyWith(
        year: pathDate.year,
        month: pathDate.month,
        day: pathDate.day,
        hour: pathDate.hour,
        minute: pathDate.minute,
      ),
    );
    if (story != null) currentStory = story;
    return currentStory;
  }
}
