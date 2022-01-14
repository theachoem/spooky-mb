import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/file_managers/story_file_manager.dart';
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
        DateTime(story.path.year, story.path.month, story.path.day),
      );
    }
  }

  DetailViewModel(
    this.currentStory,
    this.flowType,
  ) {
    currentContent = getInitialStoryContent(currentStory);
    pageController = PageController();
    readOnlyNotifier = ValueNotifier(flowType == DetailViewFlow.update);
    hasChangeNotifer = ValueNotifier(flowType == DetailViewFlow.create);
    titleController = TextEditingController(text: currentContent.title);
    storyFileManager = StoryFileManager();
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
    return true;
  }

  Future<void> save(BuildContext context) async {
    if (!hasChange) return;
    StoryModel? result = await write();
    if (result != null && result.changes.isNotEmpty) {
      currentStory = result;
      currentContent = result.changes.last;
      notifyListeners();
    }
  }

  @mustCallSuper
  Future<StoryModel?> write() async {
    StoryModel story = DetailViewModelHelper.buildStory(currentStory, currentContent, flowType);
    File? result = await storyFileManager.writeStory(story);

    if (kDebugMode) {
      print(storyFileManager.success);
      print(storyFileManager.error);
    }

    if (result != null) {
      return story;
    }
  }
}
