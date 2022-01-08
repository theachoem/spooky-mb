import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class FileViewerViewModel extends BaseViewModel {
  final File file;

  String? fileContent;
  FileViewerViewModel(this.file) {
    file.readAsString().then((value) {
      fileContent = value;
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        notifyListeners();
      });
    });
  }
}
