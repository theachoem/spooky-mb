import 'package:spooky_mb/core/databases/adapters/base_db_adapter.dart';
import 'package:spooky_mb/core/databases/models/base_db_model.dart';

class StoryContentDbModel extends BaseDbModel {
  @override
  BaseDbAdapter<BaseDbModel> get dbAdapter => throw UnimplementedError();

  final int id;
  final String? title;
  final String? plainText;
  final DateTime createdAt;
  final bool? draft;

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
    this.draft = false,
  });

  void addPage() {
    if (pages != null) {
      pages?.add([]);
    } else {
      pages = [[]];
    }
  }

  StoryContentDbModel.create({
    required this.createdAt,
    required this.id,
  })  : plainText = null,
        metadata = null,
        title = null,
        pages = [[]],
        draft = true;

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
}
