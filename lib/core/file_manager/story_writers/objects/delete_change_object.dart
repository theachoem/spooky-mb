import 'package:spooky/core/file_manager/story_writers/objects/base_writer_object.dart';
import 'package:spooky/ui/views/detail/detail_view_model.dart';

class DeleteChangeObject extends BaseWriterObject {
  final List<String> contentIds;
  DeleteChangeObject(
    DetailViewModel viewModel, {
    required this.contentIds,
  }) : super(viewModel);
}
