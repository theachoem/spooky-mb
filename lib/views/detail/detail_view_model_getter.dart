import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';

class DetailViewModelGetter {
  final StoryDbModel currentStory;
  final DetailViewFlowType flowType;
  final StoryContentDbModel currentContent;
  final String title;
  final DateTime openOn;
  final bool hasChange;
  final Map<int, QuillController> _quillControllers;
  Map<int, QuillController> get quillControllers => _quillControllers;

  DetailViewModelGetter({
    required this.currentStory,
    required this.flowType,
    required this.currentContent,
    required this.title,
    required this.openOn,
    required this.hasChange,
    required Map<int, QuillController> quillControllers,
  }) : _quillControllers = quillControllers;
}
