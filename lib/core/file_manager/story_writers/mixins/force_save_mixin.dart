import 'package:spooky/core/file_manager/story_writers/base_story_writer.dart';
import 'package:spooky/core/file_manager/story_writers/objects/base_writer_object.dart';
import 'package:spooky/core/types/response_code_type.dart';

// force save without validation
mixin ForceSaveMixin<T extends BaseStoryWriter> {
  ResponseCodeType? validate(BaseWriterObject object) {
    return null;
  }
}
