import 'package:spooky_mb/core/base/base_view_model.dart';
import 'package:spooky_mb/core/databases/models/collection_db_model.dart';
import 'package:spooky_mb/core/databases/models/story_content_db_model.dart';
import 'package:spooky_mb/core/databases/models/story_db_model.dart';
import 'package:spooky_mb/core/databases/models/tag_db_model.dart';
import 'package:spooky_mb/views/story_details/story_details_view.dart';

class StoryDetailsViewModel extends BaseViewModel {
  final StoryDetailsView params;

  StoryDetailsViewModel({
    required this.params,
  }) {
    load();
  }

  StoryDbModel? story;
  CollectionDbModel<TagDbModel>? tags;

  Future<void> load() async {
    story = await StoryDbModel.db.find(params.id);
    tags = await TagDbModel.db.where(filters: null);
    notifyListeners();
  }

  void save() async {
    StoryDbModel.db.update(story!.copyWith(
      changes: [
        story!.changes.last.copyWith(title: 'Very Good', plainText: 'This is content'),
      ],
    ));
  }
}
