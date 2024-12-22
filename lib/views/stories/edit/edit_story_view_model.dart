import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/databases/models/story_content_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/services/story_writers/default_story_writer.dart';
import 'package:spooky/core/services/story_writers/objects/default_story_object.dart';
import 'package:spooky/core/services/story_writers/objects/shared_writer_object.dart';
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

  EditingFlowType? flowType;
  StoryDbModel? story;
  StoryContentDbModel? currentContent;

  bool topToolbar = false;
  bool get showToolbarOnTop => quillControllers.isNotEmpty && topToolbar;
  bool get showToolbarOnBottom => quillControllers.isNotEmpty && !topToolbar;

  Future<void> load() async {
    if (params.storyId != null) story = await StoryDbModel.db.find(params.storyId!);
    flowType = story == null ? EditingFlowType.create : EditingFlowType.update;

    story ??= StoryDbModel.fromDate(openedOn);
    currentContent = story!.changes.isNotEmpty ? story!.changes.last : StoryContentDbModel.create(createdAt: openedOn);

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

  void toggleToolbarPosition() {
    topToolbar = !topToolbar;
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

  void changeTitle(BuildContext context) async {
    List<String>? result = await showTextInputDialog(
      title: "Rename",
      context: context,
      textFields: [
        DialogTextField(
          initialText: currentContent?.title,
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
      currentContent = currentContent!.copyWith(title: result.firstOrNull);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    quillControllers.forEach((e, k) => k.dispose());
    super.dispose();
  }
}

Document _buildDocument(List<dynamic>? document) {
  if (document != null && document.isNotEmpty) return Document.fromJson(document);
  return Document();
}

List<Document> _buildDocuments(List<List<dynamic>>? pages) {
  if (pages == null || pages.isEmpty == true) return [];
  return pages.map((page) => _buildDocument(page)).toList();
}
