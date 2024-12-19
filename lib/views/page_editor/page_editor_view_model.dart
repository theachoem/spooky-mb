import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky_mb/core/base/base_view_model.dart';
import 'package:spooky_mb/core/databases/models/story_content_db_model.dart';
import 'package:spooky_mb/core/databases/models/story_db_model.dart';
import 'package:spooky_mb/core/services/story_writers/default_story_writer.dart';
import 'package:spooky_mb/core/services/story_writers/objects/default_story_object.dart';
import 'package:spooky_mb/core/services/story_writers/objects/shared_writer_object.dart';
import 'package:spooky_mb/core/types/editing_flow_type.dart';
import 'package:spooky_mb/views/page_editor/page_editor_view.dart';

Document _buildDocument(List<dynamic>? document) {
  if (document != null && document.isNotEmpty) return Document.fromJson(document);
  return Document();
}

List<Document> _buildDocuments(List<List<dynamic>>? pages) {
  if (pages == null || pages.isEmpty == true) return [];
  return pages.map((page) => _buildDocument(page)).toList();
}

class PageEditorViewModel extends BaseViewModel {
  final PageEditorView params;

  late final PageController pageController = PageController(initialPage: params.initialPageIndex);
  final Map<int, QuillController> quillControllers = {};

  PageEditorViewModel({
    required this.params,
  }) {
    load();
  }

  @override
  void dispose() {
    pageController.dispose();
    quillControllers.forEach((e, k) => k.dispose());
    super.dispose();
  }

  EditingFlowType? flowType;
  StoryDbModel? story;
  StoryContentDbModel? currentContent;

  final DateTime openOn = DateTime.now();

  bool topToolbar = true;
  bool get showToolbarOnTop => quillControllers.isNotEmpty && topToolbar;
  bool get showToolbarOnBottom => quillControllers.isNotEmpty && !topToolbar;

  void toggleToolbarPosition() {
    topToolbar = !topToolbar;
    notifyListeners();
  }

  Future<void> load() async {
    if (params.storyId != null) story = await StoryDbModel.db.find(params.storyId!);
    flowType = story == null ? EditingFlowType.create : EditingFlowType.update;

    story ??= StoryDbModel.fromDate(openOn);
    currentContent = story!.changes.isNotEmpty ? story!.changes.last : StoryContentDbModel.create(createdAt: openOn);

    bool alreadyHasPage = currentContent?.pages?.isNotEmpty == true;
    if (!alreadyHasPage) currentContent = currentContent!..addPage();

    if (params.quillControllers != null) {
      for (int i = 0; i < params.quillControllers!.length; i++) {
        quillControllers[i] = QuillController(
          document: params.quillControllers![i]!.document,
          selection: params.quillControllers![i]!.selection,
        );
      }
    } else {
      List<Document> documents = await compute(_buildDocuments, currentContent?.pages);
      for (int i = 0; i < documents.length; i++) {
        quillControllers[i] = QuillController(
          document: documents[i],
          selection: const TextSelection.collapsed(offset: 0),
        );
      }
    }

    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    story = await DefaultStoryWriter(context).save(DefaultStoryObject(
      info: SharedWriterObject(
        hasChange: true,
        currentContent: currentContent!,
        title: currentContent!.title,
        quillControllers: quillControllers,
        flowType: flowType!,
        currentStory: story!,
        currentPageIndex: params.initialPageIndex,
      ),
    ));

    // ignore: use_build_context_synchronously
    Navigator.of(context).maybePop(story);
  }
}
