import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_turn/page_turn.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:stacked/stacked.dart';

class ContentReaderViewModel extends BaseViewModel {
  late final GlobalKey<PageTurnState> pageTurnState;
  late final PageController pageController;

  late ValueNotifier<bool> fullscreenNotifier;
  late ValueNotifier<int> pageNotifier;

  late final Timer timer;

  StoryContentModel content;
  ContentReaderViewModel(this.content) {
    pageController = PageController();
    pageTurnState = GlobalKey<PageTurnState>();
    fullscreenNotifier = ValueNotifier(false);
    pageNotifier = ValueNotifier(0);

    timer = Timer.periodic(ConfigConstant.duration, (_) {
      pageNotifier.value = pageTurnState.currentState?.pageNumber ?? 0;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    fullscreenNotifier.dispose();
    timer.cancel();
    super.dispose();
  }

  void toggleFullscreen() {
    fullscreenNotifier.value = !fullscreenNotifier.value;
  }
}
