import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/file_manager/base_file_manager.dart';
import 'package:spooky/core/file_manager/docs_manager.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/utils/helpers/file_helper.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';
import 'package:stacked/stacked.dart';

enum DetailViewFlow {
  create,
  update,
}

class DetailViewModel extends BaseViewModel with ScheduleMixin {
  DetailViewFlow get flowType => currentStory != null ? DetailViewFlow.update : DetailViewFlow.create;
  StoryModel? currentStory;

  late QuillController controller;
  late FocusNode focusNode;
  late ScrollController scrollController;
  late ValueNotifier<bool> readOnlyNotifier;
  late TextEditingController titleController;
  late DocsManager docsManager;
  late ValueNotifier<bool> hasChangeNotifer;

  DetailViewModel(this.currentStory) {
    controller = currentStory?.document != null
        ? QuillController(
            document: Document.fromJson(currentStory!.document!),
            selection: const TextSelection.collapsed(offset: 0),
          )
        : QuillController.basic();
    focusNode = FocusNode();
    scrollController = ScrollController();
    readOnlyNotifier = ValueNotifier(true);
    hasChangeNotifer = ValueNotifier(flowType == DetailViewFlow.create);
    titleController = TextEditingController(text: currentStory?.title);
    docsManager = DocsManager();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      readOnlyNotifier.addListener(() {
        if (readOnlyNotifier.value) {
          focusNode.unfocus();
        } else {
          focusNode.requestFocus();
        }
        hasChangeNotifer.value = hasChange;
      });

      controller.addListener(() {
        scheduleAction(() {
          hasChangeNotifer.value = hasChange;
        });
      });

      titleController.addListener(() {
        scheduleAction(() {
          hasChangeNotifer.value = hasChange;
        });
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    scrollController.dispose();
    readOnlyNotifier.dispose();
    titleController.dispose();
    hasChangeNotifer.dispose();
    super.dispose();
  }

  StoryModel buildStory() {
    DateTime date = DateTime.now();
    StoryModel story;

    switch (flowType) {
      case DetailViewFlow.create:
        story = buildStoryModel(date);
        break;
      case DetailViewFlow.update:
        story = currentStory?.copyWith(
              fileId: date.millisecondsSinceEpoch.toString(),
              title: titleController.text,
              createdAt: date,
              updatedAt: date,
              plainText: controller.document.toPlainText(),
              document: controller.document.toDelta().toJson(),
            ) ??
            buildStoryModel(date);
        break;
    }

    return story;
  }

  Future<DocsManager> save() async {
    StoryModel story = buildStory();
    await write(story);
    if (docsManager.success == true) {
      currentStory = story;
    }
    return docsManager;
  }

  bool get hasChange {
    if (currentStory != null) {
      return StoryModel.hasChanges(buildStory(), currentStory!);
    } else {
      return true;
    }
  }

  Future<void> write(StoryModel story) async {
    if (hasChange) {
      await docsManager.write(story);
      docsManager.success = true;
      docsManager.message = MessageSummary(
        docsManager.file != null ? FileHelper.fileName(docsManager.file!.path) : "Successfully!",
      );
    } else {
      // set success to false,
      // otherwise if !hasChange, old success value will be used
      // which is wrong.
      docsManager.success = false;
      docsManager.message = MessageSummary('Document has no changes');
    }
  }

  StoryModel buildStoryModel(DateTime date) {
    return StoryModel(
      documentId: date.millisecondsSinceEpoch.toString(),
      fileId: date.millisecondsSinceEpoch.toString(),
      starred: false,
      feeling: null,
      title: titleController.text,
      createdAt: date,
      plainText: controller.document.toPlainText(),
      document: controller.document.toDelta().toJson(),
    );
  }
}
