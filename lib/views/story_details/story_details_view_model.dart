import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky_mb/core/base/base_view_model.dart';
import 'package:spooky_mb/core/databases/models/story_content_db_model.dart';
import 'package:spooky_mb/core/databases/models/story_db_model.dart';
import 'package:spooky_mb/core/services/quill_service.dart';
import 'package:spooky_mb/routes/utils/animated_page_route.dart';
import 'package:spooky_mb/views/page_editor/page_editor_view.dart';
import 'package:spooky_mb/views/story_details/story_details_view.dart';

class StoryDetailsViewModel extends BaseViewModel {
  final StoryDetailsView params;

  late final PageController pageController;
  final ValueNotifier<double> currentPageNotifier = ValueNotifier(0);

  int get currentPage => currentPageNotifier.value.round();

  StoryDetailsViewModel({
    required this.params,
  }) {
    storyId = params.id;
    pageController = PageController();

    pageController.addListener(() {
      currentPageNotifier.value = pageController.page!;
    });

    load();
  }

  @override
  void dispose() {
    pageController.dispose();
    currentPageNotifier.dispose();
    super.dispose();
  }

  int? storyId;
  StoryDbModel? story;
  StoryContentDbModel? currentStoryContent;
  TextSelection? currentTextSelection;

  Future<void> load() async {
    if (storyId != null) story = await StoryDbModel.db.find(storyId!);
    currentStoryContent = story?.changes.lastOrNull ?? StoryContentDbModel.create();

    bool alreadyHasPage = currentStoryContent?.pages?.isNotEmpty == true;
    if (!alreadyHasPage) currentStoryContent = currentStoryContent!..addPage();

    notifyListeners();
  }

  Future<void> createNewPage(BuildContext context) async {
    if (story == null) return;
    if (currentStoryContent == null || currentStoryContent?.pages == null || pageController.page == null) return;
    if (currentStoryContent!.pages!.isEmpty == true) return;

    currentStoryContent = currentStoryContent!..addPage();
    story = story?.copyWithNewChange(currentStoryContent!);

    notifyListeners();
    pageController.animateToPage(
      currentStoryContent!.pages!.length - 1,
      duration: Durations.medium1,
      curve: Curves.ease,
    );
  }

  Future<void> goToEditPage(BuildContext context) async {
    if (currentStoryContent == null || currentStoryContent?.pages == null || pageController.page == null) return;

    int currentPage = this.currentPage;
    List<List<dynamic>> pages = currentStoryContent!.pages!;
    List<dynamic>? currentPageDocuments = pages[currentPage];

    var document = await Navigator.of(context).push(
      AnimatedPageRoute.sharedAxis(
        builder: (context) => PageEditorView(
          initialDocument: currentPageDocuments,
          initialTextSelection: currentTextSelection,
        ),
        type: SharedAxisTransitionType.vertical,
      ),
    );

    if (document is Document) {
      pages[currentPage] = document.toDelta().toJson();

      StoryContentDbModel newChange = StoryContentDbModel.create().copyWith(
        pages: pages,
        plainText: QuillService.toPlainText(document),
      );

      if (story?.id != null) {
        StoryDbModel editedStory = story!.copyWithNewChange(newChange).copyWith(month: 5);
        StoryDbModel? result = await StoryDbModel.db.update(editedStory.copyWith(updatedAt: DateTime.now()));
        storyId ??= result?.id;

        await load();
      } else {
        final now = DateTime.now();
        StoryDbModel newStory = StoryDbModel.fromNow().copyWith(changes: [newChange]);
        StoryDbModel? result = await StoryDbModel.db.create(newStory.copyWith(updatedAt: now, createdAt: now));
        storyId ??= result?.id;

        await load();
      }
    }
  }
}
