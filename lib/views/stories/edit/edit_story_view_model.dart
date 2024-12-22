import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/databases/models/story_content_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/services/story_helper.dart';
import 'package:spooky/core/types/editing_flow_type.dart';
import 'package:spooky/views/stories/edit/edit_story_view.dart';

class EditStoryViewModel extends BaseViewModel {
  final EditStoryView params;

  EditStoryViewModel({
    required this.params,
  }) {
    load();
  }

  late final PageController pageController = PageController(initialPage: params.initialPageIndex);
  final Map<int, QuillController> quillControllers = {};
  final DateTime openedOn = DateTime.now();

  int get currentPageIndex => pageController.page!.round().toInt();

  EditingFlowType? flowType;
  StoryDbModel? story;
  StoryContentDbModel? draftContent;
  ValueNotifier<DateTime?> lastSavedAtNotifier = ValueNotifier(null);

  bool topToolbar = false;
  bool get showToolbarOnTop => quillControllers.isNotEmpty && topToolbar;
  bool get showToolbarOnBottom => quillControllers.isNotEmpty && !topToolbar;

  void toggleToolbarPosition() {
    topToolbar = !topToolbar;
    notifyListeners();
  }

  Future<void> load() async {
    if (params.id != null) story = await StoryDbModel.db.find(params.id!);
    flowType = story == null ? EditingFlowType.create : EditingFlowType.update;

    lastSavedAtNotifier.value = story?.updatedAt;

    story ??= StoryDbModel.fromDate(openedOn, initialYear: params.initialYear);
    draftContent = story?.latestChange != null
        ? StoryContentDbModel.dublicate(story!.latestChange!)
        : StoryContentDbModel.create(createdAt: openedOn);

    bool alreadyHasPage = draftContent?.pages?.isNotEmpty == true;
    if (!alreadyHasPage) draftContent = draftContent!..addPage();

    if (params.quillControllers != null) {
      for (int i = 0; i < params.quillControllers!.length; i++) {
        quillControllers[i] = QuillController(
          document: params.quillControllers![i]!.document,
          selection: params.quillControllers![i]!.selection,
        )..addListener(() => silentlySave());
      }
    } else {
      List<Document> documents = await StoryHelper.buildDocuments(draftContent?.pages);
      for (int i = 0; i < documents.length; i++) {
        quillControllers[i] = QuillController(
          document: documents[i],
          selection: const TextSelection.collapsed(offset: 0),
        )..addListener(() => silentlySave());
      }
    }

    notifyListeners();
  }

  void changeTitle(BuildContext context) async {
    List<String>? result = await showTextInputDialog(
      title: "Rename",
      context: context,
      textFields: [
        DialogTextField(
          initialText: draftContent?.title,
          maxLines: 2,
          hintText: 'Title...',
          validator: (value) {
            if (value == null || value.trim().isEmpty) return "Required";
            return null;
          },
        )
      ],
    );

    if (result != null && result.firstOrNull != null) {
      draftContent = draftContent!.copyWith(title: result.firstOrNull);
      notifyListeners();

      if (context.mounted) silentlySave();
    }
  }

  Future<void> silentlySave() async {
    story = await StoryDbModel.fromDetailPage(this);
    await StoryDbModel.db.set(story!);

    lastSavedAtNotifier.value = story?.updatedAt;
  }

  @override
  void dispose() {
    pageController.dispose();
    quillControllers.forEach((e, k) => k.dispose());
    super.dispose();
  }
}
