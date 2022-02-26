import 'package:spooky/core/file_manager/story_writers/objects/default_story_object.dart';
import 'package:spooky/ui/views/detail/detail_view_model.dart';

class UpdatePageObject extends DefaultStoryObject {
  UpdatePageObject(
    DetailViewModel viewModel, {
    required this.pages,
  }) : super(viewModel);

  final List<List<dynamic>>? pages;
}
