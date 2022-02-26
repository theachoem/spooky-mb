import 'package:spooky/core/file_manager/story_writers/objects/base_writer_object.dart';
import 'package:spooky/core/file_manager/story_writers/objects/default_story_object.dart';
import 'package:spooky/ui/views/detail/detail_view_model.dart';

class DeleteChangeObject extends DefaultStoryObject {
  final List<String> contentIds;
  DeleteChangeObject(
    DetailViewModel viewModel, {
    required this.contentIds,
  }) : super(viewModel);
}
