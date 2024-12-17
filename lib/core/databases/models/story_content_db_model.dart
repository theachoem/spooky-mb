import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:spooky_mb/core/databases/models/base_db_model.dart';
import 'package:spooky_mb/core/databases/models/concerns/comparable_concern.dart';

part 'story_content_db_model.g.dart';

@CopyWith()
@JsonSerializable()
class StoryContentDbModel extends BaseDbModel with ComparableConcern {
  final int id;
  final String? title;
  final String? plainText;
  final DateTime createdAt;
  final bool? draft;

  @override
  List<String>? get includeCompareKeys => ['title', 'pages'];

  // metadata should be title + plain text
  // better if with all pages.
  final String? metadata;
  String? get safeMetadata {
    return metadata ?? [title ?? "", plainText ?? ""].join("\n");
  }

  // List: Returns JSON-serializable version of quill delta.
  List<List<dynamic>>? pages;

  StoryContentDbModel({
    required this.id,
    required this.title,
    required this.plainText,
    required this.createdAt,
    required this.pages,
    required this.metadata,
    required this.draft,
  });

  void addPage() {
    if (pages != null) {
      pages?.add([]);
    } else {
      pages = [[]];
    }
  }

  factory StoryContentDbModel.dublicate(StoryContentDbModel oldContent) {
    DateTime now = DateTime.now();
    return oldContent.copyWith(
      id: now.millisecondsSinceEpoch,
      createdAt: now,
    );
  }

  factory StoryContentDbModel.create() {
    return StoryContentDbModel(
      id: DateTime.now().millisecondsSinceEpoch,
      title: null,
      plainText: null,
      createdAt: DateTime.now(),
      pages: null,
      metadata: null,
      draft: true,
    );
  }

  @override
  Map<String, dynamic> toJson() => _$StoryContentDbModelToJson(this);
  factory StoryContentDbModel.fromJson(Map<String, dynamic> json) => _$StoryContentDbModelFromJson(json);

  // avoid save without add anythings
  bool hasDataWritten(StoryContentDbModel content) {
    List<List<dynamic>> pagesClone = content.pages ?? [];
    List<List<dynamic>> pages = [...pagesClone];

    pages.removeWhere((items) {
      bool empty = items.isEmpty;
      if (items.length == 1) {
        dynamic first = items.first;
        if (first is Map) {
          dynamic insert = items.first['insert'];
          if (insert is String) return insert.trim().isEmpty;
        }
      }
      return empty;
    });

    bool emptyPages = pages.isEmpty;
    String title = content.title ?? "";

    bool hasNoDataWritten = emptyPages && title.trim().isEmpty;
    return !hasNoDataWritten;
  }

  @override
  List<String> get excludeCompareKeys {
    return [
      'id',
      'plain_text',
      'created_at',
      'metadata',
      'draft',
    ];
  }
}
