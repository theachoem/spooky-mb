import 'package:spooky/core/file_manager/story_writers/objects/default_story_object.dart';
import 'package:spooky/ui/views/detail/detail_view_model.dart';

class RestoreStoryObject extends DefaultStoryObject {
  RestoreStoryObject(
    DetailViewModel viewModel, {
    required this.contentId,
  }) : super(viewModel);

  final String contentId;
}
