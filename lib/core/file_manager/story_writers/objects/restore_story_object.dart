import 'package:spooky/core/file_manager/story_writers/objects/base_writer_object.dart';
import 'package:spooky/ui/views/detail/detail_view_model.dart';

class RestoreStoryObject extends BaseWriterObject {
  RestoreStoryObject(
    DetailViewModel viewModel, {
    required this.contentId,
  }) : super(viewModel);

  final String contentId;
}
