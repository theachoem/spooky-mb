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
    bool success = deleteManager.success == true;
    if (success) await load();
    return success;
  }

  Future<bool> unarchiveDocument(StoryModel story) async {
    await archiveManager.unarchiveDocument(story);
    bool success = archiveManager.success == true;
    if (success) await load();
    return archiveManager.success == true;
  }
}
