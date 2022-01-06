import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:stacked/stacked.dart';

class DetailViewModel extends BaseViewModel {
  late QuillController controller;
  late FocusNode focusNode;
  late ScrollController scrollController;
  late ValueNotifier<bool> readOnlyNotifier;

  DetailViewModel() {
    controller = QuillController.basic();
    focusNode = FocusNode();
    scrollController = ScrollController();
    readOnlyNotifier = ValueNotifier(true);

    readOnlyNotifier.addListener(() {
      if (readOnlyNotifier.value) {
        focusNode.unfocus();
      } else {
        focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    scrollController.dispose();
    readOnlyNotifier.dispose();
    super.dispose();
  }
}
