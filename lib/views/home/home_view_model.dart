import 'package:spooky_mb/core/base/base_view_model.dart';
import 'package:spooky_mb/core/databases/models/collection_db_model.dart';
import 'package:spooky_mb/core/databases/models/story_db_model.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel() {
    load();
  }

  CollectionDbModel<StoryDbModel>? stories;

  Future<void> load() async {
    stories = await StoryDbModel.db.where();
    notifyListeners();
  }
}
