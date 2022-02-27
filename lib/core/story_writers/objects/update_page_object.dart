import 'package:spooky/core/story_writers/objects/default_story_object.dart';
import 'package:spooky/ui/views/detail/detail_view_model_getter.dart';

class UpdatePageObject extends DefaultStoryObject {
  UpdatePageObject(
    DetailViewModelGetter info, {
    required this.pages,
  }) : super(info);

  final List<List<dynamic>>? pages;
}
