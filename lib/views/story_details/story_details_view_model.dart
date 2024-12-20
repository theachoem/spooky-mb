// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/databases/models/story_content_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/routes/utils/animated_page_route.dart';
import 'package:spooky/views/page_editor/page_editor_view.dart';
import 'package:spooky/views/story_details/story_details_view.dart';

Document _buildDocument(List<dynamic>? document) {
  if (document != null && document.isNotEmpty) return Document.fromJson(document);
  return Document();
}

List<Document> _buildDocuments(List<List<dynamic>>? pages) {
  if (pages == null || pages.isEmpty == true) return [];
  return pages.map((page) => _buildDocument(page)).toList();
}

class StoryDetailsViewModel extends BaseViewModel {
  final StoryDetailsView params;

  late final PageController pageController;
  final ValueNotifier<double> currentPageNotifier = ValueNotifier(0);

  StoryDetailsViewModel({
    required this.params,
    required BuildContext context,
  }) {
    pageController = PageController();

    pageController.addListener(() {
      currentPageNotifier.value = pageController.page!;
    });

    load(params.id);
  }

  int get currentPage => currentPageNotifier.value.round();
  final Map<int, QuillController> quillControllers = {};

  StoryDbModel? story;
  StoryContentDbModel? currentContent;
  TextSelection? currentTextSelection;

  @override
  void dispose() {
    pageController.dispose();
    currentPageNotifier.dispose();
    super.dispose();
  }

  Future<void> load(int? id) async {
    if (id != null) story = await StoryDbModel.db.find(id);
    currentContent = story?.changes.lastOrNull ?? StoryContentDbModel.create();

    bool alreadyHasPage = currentContent?.pages?.isNotEmpty == true;
    if (!alreadyHasPage) currentContent = currentContent!..addPage();

    List<Document> documents = await compute(_buildDocuments, currentContent?.pages);
    for (int i = 0; i < documents.length; i++) {
      quillControllers[i] = QuillController(
        document: documents[i],
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    notifyListeners();
  }

  Future<void> goToEditPage(BuildContext context) async {
    if (currentContent == null || currentContent?.pages == null || pageController.page == null) return;
    int currentPage = this.currentPage;

    var result = await Navigator.of(context).push(
      AnimatedPageRoute.sharedAxis(
        type: SharedAxisTransitionType.vertical,
        builder: (context) => PageEditorView(
          storyId: story!.id,
          initialPageIndex: currentPage,
          quillControllers: quillControllers,
        ),
      ),
    );

    if (result is StoryDbModel) {
      await load(result.id);
    }
  }
}
