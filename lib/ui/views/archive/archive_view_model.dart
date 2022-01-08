import 'package:spooky/core/file_manager/archive_manager.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:stacked/stacked.dart';

class ArchiveViewModel extends BaseViewModel {
  final ArchiveManager manager = ArchiveManager();
  List<StoryModel>? stories;

  ArchiveViewModel() {
    load();
  }

  Future<void> load() async {
    List<StoryModel>? result = await manager.fetchAll();
    stories = result ?? [];
    notifyListeners();
  }
}
