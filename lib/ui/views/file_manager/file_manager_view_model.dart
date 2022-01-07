import 'dart:io';
import 'package:stacked/stacked.dart';

class FileManagerViewModel extends BaseViewModel {
  final Directory directory;
  List<FileSystemEntity> parents = [];

  FileManagerViewModel(this.directory) {
    load(reload: false);
  }

  String appBarTitle() {
    return directory.absolute.path.split("/").last;
  }

  void load({bool reload = true}) {
    parents = directory.listSync();
    if (reload) notifyListeners();
  }
}
