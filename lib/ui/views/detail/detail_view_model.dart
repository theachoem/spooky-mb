import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/file_managers/story_file_manager.dart';
import 'package:spooky/core/notification/channels/auto_save_channel.dart';
import 'package:spooky/core/types/response_code_type.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/core/services/initial_tab_service.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/ui/views/detail/detail_view_model_helper.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';
import 'package:stacked/stacked.dart';

class DetailViewModel extends BaseViewModel with ScheduleMixin, WidgetsBindingObserver {
  late DateTime openOn;

  late StoryModel currentStory;
  late StoryContentModel currentContent;
  late PageController pageController;

  late final ValueNotifier<bool> readOnlyNotifier;
  late final TextEditingController titleController;
  late final ValueNotifier<bool> hasChangeNotifer;
  late final FocusNode titleFocusNode;

  // has 1 or more controller inited
  late final ValueNotifier<bool> quillControllerInitedNotifier;
  late final ValueNotifier<bool> toolbarVisibleNotifier;

  StoryFileManager storyFileManager = StoryFileManager();
  Map<int, QuillController> quillControllers = {};
  Map<int, FocusNode> focusNodes = {};

  DetailViewFlowType flowType;
  StoryContentModel getInitialStoryContent(StoryModel story) {
    if (story.changes.isNotEmpty) {
      return story.changes.last;
    } else {
      return StoryContentModel.create(
        createdAt: DateTime(story.path.year, story.path.month, story.path.day),
        id: openOn.millisecondsSinceEpoch.toString(),
      );
    }
  }

  int? get currentIndex => pageController.hasClients ? pageController.page?.toInt() : null;
  FocusNode? get currentFocusNode {
    if (focusNodes.containsKey(currentIndex)) {
      return focusNodes[currentIndex];
    }
    return null;
  }

  void setQuillController(int index, QuillController controller) {
    quillControllers[index] = controller;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (quillControllerInitedNotifier.value) return;
      quillControllerInitedNotifier.value = true;
    });
  }

  QuillController? get currentQuillController {
    if (quillControllers.containsKey(currentIndex)) {
      return quillControllers[currentIndex];
    }
    return null;
  }

  DetailViewModel(
    this.currentStory,
    this.flowType,
  ) {
    openOn = DateTime.now();
    currentContent = getInitialStoryContent(currentStory);
    pageController = PageController();
    readOnlyNotifier = ValueNotifier(flowType == DetailViewFlowType.update);
    hasChangeNotifer = ValueNotifier(flowType == DetailViewFlowType.create);
    quillControllerInitedNotifier = ValueNotifier(false);
    toolbarVisibleNotifier = ValueNotifier(false);
    titleFocusNode = FocusNode();
    titleController = TextEditingController(text: currentContent.title);

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _setListener();
    });

    WidgetsBinding.instance?.addObserver(this);
  }

  void _setListener() {
    readOnlyNotifier.addListener(() {
      if (readOnlyNotifier.value) {
        currentFocusNode?.unfocus();
      } else {
        currentFocusNode?.requestFocus();
      }
      hasChangeNotifer.value = hasChange;
      toolbarVisibleNotifier.value = !readOnlyNotifier.value;
    });

    titleController.addListener(() {
      scheduleAction(() {
        hasChangeNotifer.value = hasChange;
      });
    });
  }

  List<List<dynamic>> get documents {
    List<List<dynamic>>? pages = currentContent.pages;
    return pages ?? [];
  }

  void addPage() {
    currentContent.addPage();
    notifyListeners();
    Future.delayed(ConfigConstant.fadeDuration).then((value) {
      pageController.animateToPage(
        documents.length - 1,
        duration: ConfigConstant.duration,
        curve: Curves.ease,
      );
    });
  }

  void onChange(Document document) {
    scheduleAction(() {
      hasChangeNotifer.value = hasChange;
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      pageController.dispose();
      readOnlyNotifier.dispose();
      titleController.dispose();
      hasChangeNotifer.dispose();
      quillControllerInitedNotifier.dispose();
    });
    WidgetsBinding.instance?.removeObserver(this);
  }

  bool get hasChange {
    if (currentStory.changes.isEmpty) return true;
    return DetailViewModelHelper.buildContent(
      currentContent,
      quillControllers,
      titleController,
      openOn,
    ).hasChanges(currentStory.changes.last);
  }

  Future<void> restore(StoryContentModel content, BuildContext context) async {
    // save current version which may not saved
    await _save();

    // Set currentContent is required. It will be used in buildStory()
    currentContent = content;

    ResponseCodeType code = await _save(restore: true);
    String message;

    switch (code) {
      case ResponseCodeType.success:
        flowType = DetailViewFlowType.update;
        notifyListeners();
        message = "Restored";
        break;
      case ResponseCodeType.noChange:
        message = "Document has no changes";
        break;
      case ResponseCodeType.fail:
        message = "Restore unsuccessfully!";
        break;
    }
    App.of(context)?.showSpSnackBar(message);

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Navigator.of(context).popAndPushNamed(
        SpRouteConfig.detail,
        arguments: DetailArgs(
          initialStory: currentStory,
          intialFlow: DetailViewFlowType.update,
        ),
      );
    });
  }

  Future<void> deleteChange(List<String> contentIds, BuildContext context) async {
    currentStory.removeChangeByIds(contentIds);
    return save(context, force: true);
  }

  Future<void> updatePage(BuildContext context, StoryContentModel value) async {
    currentContent.pages = value.pages;
    quillControllers.clear();
    await save(context, force: true, shouldRefresh: false, shouldShowSnackbar: false);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Navigator.of(context).pushReplacementNamed(
        SpRouteConfig.detail,
        arguments: DetailArgs(
          initialStory: currentStory,
          intialFlow: DetailViewFlowType.update,
        ),
      );
    });
  }

  Future<void> save(
    BuildContext context, {
    bool force = false,
    bool shouldRefresh = true,
    bool shouldShowSnackbar = true,
  }) async {
    ResponseCodeType code = await _save(force: force);
    String message;

    switch (code) {
      case ResponseCodeType.success:
        flowType = DetailViewFlowType.update;
        if (shouldRefresh) notifyListeners();
        message = "Saved";
        break;
      case ResponseCodeType.noChange:
        message = "Document has no changes";
        break;
      case ResponseCodeType.fail:
        message = "Save unsuccessfully!";
        break;
    }

    if (shouldShowSnackbar || code != ResponseCodeType.success) {
      App.of(context)?.showSpSnackBar(message);
    }
  }

  @mustCallSuper
  Future<ResponseCodeType> _save({bool restore = false, bool force = false}) async {
    if (!hasChange && !force) return ResponseCodeType.noChange;
    StoryModel? result = await write(restore: restore);
    if (result != null && result.changes.isNotEmpty) {
      currentStory = result;
      currentContent = result.changes.last;
      return ResponseCodeType.success;
    }
    return ResponseCodeType.fail;
  }

  @mustCallSuper
  Future<StoryModel?> write({bool restore = false}) async {
    StoryModel story = DetailViewModelHelper.buildStory(
      currentStory,
      currentContent,
      flowType,
      quillControllers,
      titleController,
      openOn,
      restore,
    );

    File? result = await storyFileManager.writeStory(story);
    if (kDebugMode) {
      print("+++ Write +++");
      print("Success: ${storyFileManager.success}");
      print("Message: ${storyFileManager.error}");
      print("Path: ${result?.absolute.path}");
    }

    if (result != null) {
      return story;
    }
    return null;
  }

  bool hasAutosaved = false;
  Future<void> autosave() async {
    if (hasChange) {
      ResponseCodeType code = await _save();
      Future.delayed(ConfigConstant.fadeDuration).then((value) {
        switch (code) {
          case ResponseCodeType.success:
            hasAutosaved = true;
            AutoSaveChannel().show(
              title: "Document is saved",
              body: "Saved",
              payload: AutoSavePayload(
                currentStory.file?.path ?? currentStory.path.toFullPath(),
              ),
            );
            break;
          case ResponseCodeType.noChange:
            break;
          case ResponseCodeType.fail:
            AutoSaveChannel().show(
              title: "Document isn't saved!",
              body: "Error",
              payload: AutoSavePayload(
                currentStory.file?.path ?? currentStory.path.toFullPath(),
              ),
            );
            break;
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    List<AppLifecycleState> shouldSaveInStates = [AppLifecycleState.paused, AppLifecycleState.inactive];
    if (shouldSaveInStates.contains(state)) {
      autosave();

      // if user close app, we store initial tab on home
      // so they new it is saved.
      InitialStoryTabService.setInitialTab(
        currentStory.path.year,
        currentStory.path.month,
      );
    }
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed && hasAutosaved) {
      hasAutosaved = false;
      hasChangeNotifer.value = hasChange;
    }
  }
}
