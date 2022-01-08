import 'dart:io';
import 'package:spooky/ui/views/file_manager/file_manager_view.dart';
import 'package:stacked/stacked.dart';

enum FileManagerLayout {
  list,
  grid,
}

class FileManagerViewModel extends BaseViewModel {
  final Directory directory;
  final FileManagerFlow fileManagerFlow;

  List<FileSystemEntity> parents = [];
  FileManagerLayout layout = FileManagerLayout.grid;

  FileManagerViewModel(this.directory, this.fileManagerFlow) {
    if (fileManagerFlow == FileManagerFlow.viewChanges) layout = FileManagerLayout.list;
    load(reload: false);
  }

  String appBarTitle() {
    switch (fileManagerFlow) {
      case FileManagerFlow.explore:
        return directory.absolute.path.split("/").last;
      case FileManagerFlow.viewChanges:
        return "Changes History";
    }
  }

  void nextLayout() {
    List<FileManagerLayout> values = FileManagerLayout.values;
    FileManagerLayout _layout = values[(values.indexOf(layout) + 1) % values.length];
    setLayout(_layout);
  }

  void setLayout(FileManagerLayout layout) {
    if (this.layout == layout) return;
    this.layout = layout;
    notifyListeners();
  }

  void load({bool reload = true}) {
    parents = directory.listSync();
    if (reload) notifyListeners();
  }
}
