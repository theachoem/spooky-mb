import 'package:spooky_mb/core/services/story_writers/objects/shared_writer_object.dart';

abstract class BaseWriterObject {
  final SharedWriterObject info;

  BaseWriterObject({
    required this.info,
  });
}
