import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/file_manager/base_file_manager.dart';
import 'package:spooky/core/file_manager/docs_manager.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/notifications/app_notification.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';
import 'package:stacked/stacked.dart';

enum DetailViewFlow {
  create,
  update,
}

class DetailViewModel extends BaseViewModel with ScheduleMixin, WidgetsBindingObserver {
  late StoryModel currentStory;

  late QuillController controller;
  late FocusNode focusNode;
  late ScrollController scrollController;
  late ValueNotifier<bool> readOnlyNotifier;
  late TextEditingController titleController;
  late DocsManager docsManager;
  late ValueNotifier<bool> hasChangeNotifer;

  bool get hasChange {
    return StoryModel.hasChanges(buildStory(), currentStory);
  }

  QuillController _getDocumentController() {
    if (currentStory.document != null) {
      return QuillController(
        document: Document.fromJson(currentStory.document!),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      return QuillController.basic();
    }
  }

  DetailViewModel(this.currentStory) {
    controller = _getDocumentController();
    focusNode = FocusNode();
    scrollController = ScrollController();
    readOnlyNotifier = ValueNotifier(currentStory.flowType == DetailViewFlow.update);
    hasChangeNotifer = ValueNotifier(currentStory.flowType == DetailViewFlow.create);
    titleController = TextEditingController(text: currentStory.title);
    docsManager = DocsManager();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _setListener();
    });
    WidgetsBinding.instance?.addObserver(this);
  }

  void _setListener() {
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
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    scrollController.dispose();
    readOnlyNotifier.dispose();
    titleController.dispose();
    hasChangeNotifer.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  Future<void> _save() async {
    StoryModel story = buildStory();
    await _write(story);
    if (docsManager.success == true) currentStory = story;

    if (kDebugMode) {
      print(docsManager.file?.absolute.path);
      print(docsManager.success);
      print(docsManager.error);
    }
  }

  bool hasAutosaved = false;
  Future<void> autosave() async {
    if (hasChange) {
      await _save();
      Future.delayed(ConfigConstant.fadeDuration).then((value) {
        if (docsManager.success == true) {
          hasAutosaved = true;
          AppNotification().displayNotification(
            plainTitle: "Document is saved",
            plainBody: "Saved: ${docsManager.message}",
            payload: currentStory,
          );
        } else {
          AppNotification().displayNotification(
            plainTitle: "Document isn't saved!",
            plainBody: "Error: ${docsManager.message}",
            payload: currentStory,
          );
        }
      });
    }
  }

  Future<void> save(BuildContext context) async {
    await _save();
    Future.delayed(ConfigConstant.fadeDuration).then((value) {
      if (docsManager.success == true) {
        App.of(context)?.showSpSnackBar("Saved: ${docsManager.message}");
      } else {
        App.of(context)?.showSpSnackBar("Error: ${docsManager.message}");
      }
    });
  }

  @mustCallSuper
  StoryModel buildStory() {
    DateTime now = DateTime.now();
    StoryModel story;

    switch (currentStory.flowType) {
      case DetailViewFlow.create:
        story = StoryModel(
          documentId: StoryModel.documentIdFromDate(now),
          fileId: now.millisecondsSinceEpoch.toString(),
          starred: false,
          feeling: null,
          title: titleController.text,
          createdAt: now,
          pathDate: currentStory.pathDate ?? now,
          plainText: controller.document.toPlainText(),
          document: controller.document.toDelta().toJson(),
        );
        break;
      case DetailViewFlow.update:
        // "update" mean that documentId != null
        story = currentStory.copyWith(
          fileId: now.millisecondsSinceEpoch.toString(),
          title: titleController.text,
          createdAt: now,
          pathDate: currentStory.pathDate ?? now,
          plainText: controller.document.toPlainText(),
          document: controller.document.toDelta().toJson(),
        );
        break;
    }

    return story;
  }

  @mustCallSuper
  Future<void> _write(StoryModel story) async {
    if (hasChange) {
      assert(story.documentId != null);
      assert(story.fileId != null);
      assert(story.pathDate != null);
      await docsManager.write(story);
    } else {
      // set success to false,
      // otherwise if !hasChange, old success value will be used
      // which is wrong.
      docsManager.message = MessageSummary('Document has no changes');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    List<AppLifecycleState> shouldSaveInStates = [AppLifecycleState.paused, AppLifecycleState.inactive];
    if (shouldSaveInStates.contains(state)) autosave();
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed && hasAutosaved) {
      hasAutosaved = false;
      hasChangeNotifer.value = hasChange;
    }
  }
}
