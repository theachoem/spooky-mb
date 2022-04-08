import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/utils/mixins/comparable_mixin.dart';

part 'story_content_v2_model.g.dart';

@CopyWith()
@JsonSerializable()
class StoryContentV2Model extends BaseModel with ComparableMixin {
  final int id;
  final String? title;
  final String? plainText;
  final DateTime createdAt;

  // List: Returns JSON-serializable version of quill delta.
  List<List<dynamic>>? pages;

  StoryContentV2Model({
    required this.id,
    required this.title,
    required this.plainText,
    required this.createdAt,
    required this.pages,
  });

  void addPage() {
    if (pages != null) {
      pages?.add([]);
    } else {
      pages = [[]];
    }
  }

  StoryContentV2Model restore(StoryContentV2Model oldContent) {
    DateTime now = DateTime.now();
    return oldContent.copyWith(
      id: now.millisecondsSinceEpoch,
      createdAt: now,
    );
  }

  StoryContentV2Model.create({
    required this.createdAt,
    required this.id,
  })  : plainText = null,
        title = null,
        pages = [[]];

  @override
  Map<String, dynamic> toJson() => _$StoryContentV2ModelToJson(this);
  factory StoryContentV2Model.fromJson(Map<String, dynamic> json) => _$StoryContentV2ModelFromJson(json);

  @override
  String? get objectId => id.toString();

  @override
  List<String> get excludeCompareKeys {
    return [
      'id',
      'plain_text',
      'created_at',
    ];
  }
}
