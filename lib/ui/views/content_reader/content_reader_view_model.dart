import 'package:flutter/material.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:stacked/stacked.dart';

class ContentReaderViewModel extends BaseViewModel {
  late final PageController pageController;

  StoryContentModel content;
  ContentReaderViewModel(this.content) {
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
