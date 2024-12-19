import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky_mb/core/databases/models/story_content_db_model.dart';
import 'package:spooky_mb/core/databases/models/story_db_model.dart';
import 'package:spooky_mb/core/types/editing_flow_type.dart';

class SharedWriterObject {
  final bool hasChange;
  final StoryContentDbModel currentContent;
  final Map<int, QuillController> quillControllers;
  final String? title;
  final EditingFlowType flowType;
  final StoryDbModel currentStory;
  final int currentPageIndex;

  SharedWriterObject({
    required this.hasChange,
    required this.currentContent,
    required this.title,
    required this.flowType,
    required this.currentStory,
    required this.quillControllers,
    required this.currentPageIndex,
  });
}
