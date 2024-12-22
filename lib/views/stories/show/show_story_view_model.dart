import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/databases/models/story_content_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/services/story_helper.dart';
import 'package:spooky/views/stories/show/show_story_view.dart';

class ShowStoryViewModel extends BaseViewModel {
  final ShowStoryView params;

  ShowStoryViewModel({
    required this.params,
    required BuildContext context,
  }) {
    pageController = PageController();
    pageController.addListener(() {
      currentPageNotifier.value = pageController.page!;
    });

    load(params.id);
  }

  late final PageController pageController;
  final ValueNotifier<double> currentPageNotifier = ValueNotifier(0);
  Map<int, QuillController> quillControllers = {};

  int get currentPage => currentPageNotifier.value.round();

  StoryDbModel? story;
  StoryContentDbModel? draftContent;
  TextSelection? currentTextSelection;

  Future<void> load(int? id) async {
    if (id != null) story = await StoryDbModel.db.find(id);

    draftContent = story?.latestChange != null
        ? StoryContentDbModel.dublicate(story!.latestChange!)
        : StoryContentDbModel.create(createdAt: DateTime.now());

    bool alreadyHasPage = draftContent?.pages?.isNotEmpty == true;
    if (!alreadyHasPage) draftContent = draftContent!..addPage();

    quillControllers = await StoryHelper.buildQuillControllers(draftContent!, readOnly: true);
    notifyListeners();
  }

  void renameTitle(BuildContext context) async {
    if (story == null || draftContent == null) return;

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
      draftContent = draftContent!.copyWith(title: result.first);
      story = story!.copyWith(latestChange: draftContent!);

      StoryDbModel.db.set(story!);
      notifyListeners();
    }
  }

  Future<void> goToEditPage(BuildContext context) async {
    if (draftContent == null || draftContent?.pages == null || pageController.page == null) return;
    await context.push('/stories/${story!.id}/edit?initialPageIndex=$currentPage', extra: quillControllers);
    await load(story?.id);
  }

  Future<void> goToChangesPage(BuildContext context) async {
    await context.push('/stories/${story!.id}/changes');
    await load(story?.id);
  }

  @override
  void dispose() {
    pageController.dispose();
    currentPageNotifier.dispose();
    quillControllers.forEach((e, k) => k.dispose());
    super.dispose();
  }
}
