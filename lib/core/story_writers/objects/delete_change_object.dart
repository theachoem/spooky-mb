import 'package:spooky/core/story_writers/objects/default_story_object.dart';
import 'package:spooky/views/detail/detail_view_model_getter.dart';

class DeleteChangeObject extends DefaultStoryObject {
  final List<int> contentIds;

  DeleteChangeObject(
    DetailViewModelGetter info, {
    required this.contentIds,
  }) : super(info);
}
