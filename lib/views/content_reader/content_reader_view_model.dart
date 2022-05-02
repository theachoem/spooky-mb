import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/base/base_view_model.dart';

class ContentReaderViewModel extends BaseViewModel {
  late final PageController pageController;

  StoryContentDbModel content;
  Map<int, QuillController> quillControllers = {};

  ContentReaderViewModel(this.content) {
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
}
