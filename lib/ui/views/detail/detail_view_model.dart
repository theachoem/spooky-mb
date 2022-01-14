import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/file_managers/story_file_manager.dart';
import 'package:spooky/core/file_managers/types/response_code.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/ui/views/detail/helper.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';
import 'package:stacked/stacked.dart';

enum DetailViewFlow {
  create,
  update,
}

class DetailViewModel extends BaseViewModel with ScheduleMixin {
  late DateTime openOn;

  late StoryModel currentStory;
  late StoryContentModel currentContent;
  late PageController pageController;

  late ValueNotifier<bool> readOnlyNotifier;
  late TextEditingController titleController;
  late StoryFileManager storyFileManager;
  late ValueNotifier<bool> hasChangeNotifer;

  Map<int, QuillController> quillControllers = {};
  Map<int, FocusNode> focusNodes = {};

  DetailViewFlow flowType;
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
  }

  QuillController? get currentQuillController {
    if (quillControllers.containsKey(currentIndex)) {
      return quillControllers[currentIndex];
    }
  }

  DetailViewModel(
    this.currentStory,
    this.flowType,
  ) {
    openOn = DateTime.now();
    currentContent = getInitialStoryContent(currentStory);
    pageController = PageController();
    readOnlyNotifier = ValueNotifier(flowType == DetailViewFlow.update);
    hasChangeNotifer = ValueNotifier(flowType == DetailViewFlow.create);
    titleController = TextEditingController(text: currentContent.title);
    storyFileManager = StoryFileManager();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _setListener();
    });
  }

  void _setListener() {
    readOnlyNotifier.addListener(() {
      if (readOnlyNotifier.value) {
        currentFocusNode?.unfocus();
      } else {
        currentFocusNode?.requestFocus();
      }
      hasChangeNotifer.value = hasChange;
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
  }

  void onChange(Document document) {
    scheduleAction(() {
      hasChangeNotifer.value = hasChange;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    readOnlyNotifier.dispose();
    titleController.dispose();
    hasChangeNotifer.dispose();
    super.dispose();
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

  Future<void> save(BuildContext context) async {
    ResponseCode code = await _save();
    String message;

    switch (code) {
      case ResponseCode.success:
        flowType = DetailViewFlow.update;
        notifyListeners();
        message = "Save";
        break;
      case ResponseCode.noChange:
        message = "Document has no changes";
        break;
      case ResponseCode.fail:
        message = "Save unsuccessfully!";
        break;
    }

    App.of(context)?.showSpSnackBar(message);
  }

  @mustCallSuper
  Future<ResponseCode> _save() async {
    if (!hasChange) return ResponseCode.noChange;
    StoryModel? result = await write();
    if (result != null && result.changes.isNotEmpty) {
      currentStory = result;
      currentContent = result.changes.last;
      return ResponseCode.success;
    }
    return ResponseCode.fail;
  }

  @mustCallSuper
  Future<StoryModel?> write() async {
    StoryModel story = DetailViewModelHelper.buildStory(
      currentStory,
      currentContent,
      flowType,
      quillControllers,
      titleController,
      openOn,
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
  }
}
