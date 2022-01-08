import 'package:spooky/core/file_manager/archive_manager.dart';
import 'package:spooky/core/file_manager/delete_manager.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:stacked/stacked.dart';

class ArchiveViewModel extends BaseViewModel {
  final DeleteManager deleteManager = DeleteManager();
  final ArchiveManager archiveManager = ArchiveManager();
  List<StoryModel>? stories;

  ArchiveViewModel() {
    load();
  }

  Future<void> load() async {
    List<StoryModel>? result = await archiveManager.fetchAll();
    stories = result ?? [];
    notifyListeners();
  }

  Future<bool> delete(StoryModel story) async {
    await deleteManager.delete(story);
    return deleteManager.success == true;
  }

  Future<bool> unachieveDocument(StoryModel story) async {
    await archiveManager.unachieveDocument(story);
    return archiveManager.success == true;
  }
}
