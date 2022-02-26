import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:stacked/stacked.dart';

mixin DetailViewModelUiMixin on BaseViewModel {
  late final DateTime openOn;

  late final ValueNotifier<bool> readOnlyNotifier;
  late final ValueNotifier<bool> hasChangeNotifer;
  late final ValueNotifier<bool> toolbarVisibleNotifier;
  late final ValueNotifier<bool> quillControllerInitedNotifier;
  late final PageController pageController;
  late final TextEditingController titleController;
  late final FocusNode titleFocusNode;

  final Map<int, FocusNode> _focusNodes = {};
  final Map<int, QuillController> quillControllers = {};

  bool hasAutosaved = true;

  void setQuillController(int index, QuillController controller) {
    quillControllers[index] = controller;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (quillControllerInitedNotifier.value) return;
      quillControllerInitedNotifier.value = true;
    });
  }

  void setFocusNode(int index, FocusNode focusNode) {
    _focusNodes[index] = focusNode;
  }

  int? get currentIndex => pageController.hasClients ? pageController.page?.toInt() : null;
  FocusNode? get currentFocusNode {
    if (_focusNodes.containsKey(currentIndex)) return _focusNodes[currentIndex];
    return null;
  }

  FocusNode? focusNodeAt(int index) => _focusNodes[index];
  StoryContentModel initialContent(StoryModel story) {
    if (story.changes.isNotEmpty) {
      return story.changes.last;
    } else {
      return StoryContentModel.create(
        createdAt: DateTime(story.path.year, story.path.month, story.path.day),
        id: openOn.millisecondsSinceEpoch.toString(),
      );
    }
  }

  void initMixinState(DetailViewFlowType flowType, StoryContentModel content) {
    openOn = DateTime.now();
    readOnlyNotifier = ValueNotifier(flowType == DetailViewFlowType.update);
    hasChangeNotifer = ValueNotifier(flowType == DetailViewFlowType.create);
    toolbarVisibleNotifier = ValueNotifier(false);
    quillControllerInitedNotifier = ValueNotifier(false);
    pageController = PageController();
    titleController = TextEditingController(text: content.title);
    titleFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    readOnlyNotifier.dispose();
    hasChangeNotifer.dispose();
    toolbarVisibleNotifier.dispose();
    quillControllerInitedNotifier.dispose();
    pageController.dispose();
    titleController.dispose();
    titleFocusNode.dispose();
  }
}
