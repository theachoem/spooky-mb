import 'package:spooky/core/story_writers/objects/default_story_object.dart';
import 'package:spooky/ui/views/detail/detail_view_model_getter.dart';

class RestoreStoryObject extends DefaultStoryObject {
  final String contentId;

  RestoreStoryObject(
    DetailViewModelGetter info, {
    required this.contentId,
  }) : super(info);
}
