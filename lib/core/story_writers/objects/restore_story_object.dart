import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/story_writers/objects/default_story_object.dart';
import 'package:spooky/views/detail/detail_view_model_getter.dart';

class RestoreStoryObject extends DefaultStoryObject {
  final int contentId;
  final StoryDbModel storyFromChangesView;

  RestoreStoryObject(
    DetailViewModelGetter info, {
    required this.contentId,
    required this.storyFromChangesView,
  }) : super(info);
}
