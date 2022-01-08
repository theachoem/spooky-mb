import 'dart:convert';

import 'package:spooky/core/file_manager/docs_manager.dart';
import 'package:spooky/core/route/router.dart' as route;
import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/file_manager/base_fm_constructor_mixin.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/ui/views/detail/detail_view_model.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

part 'story_model.g.dart';

@JsonSerializable()
class StoryModel extends BaseModel {
  final String? documentId;
  final String? fileId;
  final bool? starred;
  final String? feeling;
  final String? title;
  final DateTime? createdAt;
  final String? plainText;

  // we store document in this path
  final DateTime? pathDate;

  // Returns JSON-serializable version of quill delta.
  final List<dynamic>? document;

  @JsonKey(ignore: true)
  final String? parentPath;

  // /Users/../87B-E36A9EF0C9F1/Documents/docs/2022/Jan/8/1641634151020
  // => FilePath.archive
  FilePath? get filePath {
    var result = parentPath?.replaceAll(FileHelper.directory.absolute.path + "/", "").split("/");

    if ((result?.length ?? 0) >= 1) {
      for (FilePath e in FilePath.values) {
        if (e.name == result![0]) {
          return e;
        }
      }
    }
  }

  StoryModel({
    required this.documentId,
    required this.fileId,
    required this.starred,
    required this.feeling,
    required this.title,
    required this.createdAt,
    required this.pathDate,
    required this.plainText,
    required this.document,
    this.parentPath,
  });

  DetailViewFlow get flowType => documentId != null ? DetailViewFlow.update : DetailViewFlow.create;

  factory StoryModel.create({required DateTime pathDate}) {
    return StoryModel(
      documentId: null,
      fileId: null,
      starred: null,
      feeling: null,
      title: null,
      pathDate: pathDate,
      createdAt: null,
      plainText: null,
      document: null,
    );
  }

  @override
  String? get objectId => fileId;

  @override
  Map<String, dynamic> toJson() => _$StoryModelToJson(this);
  factory StoryModel.fromJson(Map<String, dynamic> json) => _$StoryModelFromJson(json);

  static List<String> get excludeCompareKeys {
    return [
      'document_id',
      'file_id',
      'created_at',
      'path_date',
    ];
  }

  static String keepComparableKeys(StoryModel model) {
    Map<String, dynamic> json = model.toJson();
    json.removeWhere((key, value) {
      return excludeCompareKeys.contains(key);
    });
    return jsonEncode(json);
  }

  static String documentIdFromDate(DateTime date) => date.millisecondsSinceEpoch.toString();

  static bool hasChanges(StoryModel m1, StoryModel m2) {
    return keepComparableKeys(m1) != keepComparableKeys(m2);
  }

  StoryModel copyWith({
    String? documentId,
    String? fileId,
    bool? starred,
    String? feeling,
    String? title,
    DateTime? createdAt,
    DateTime? pathDate,
    String? plainText,
    List<dynamic>? document,
    String? parentPath,
  }) {
    return StoryModel(
      documentId: documentId ?? this.documentId,
      fileId: fileId ?? this.fileId,
      starred: starred ?? this.starred,
      feeling: feeling ?? this.feeling,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      pathDate: pathDate ?? this.pathDate,
      plainText: plainText ?? this.plainText,
      document: document ?? this.document,
      parentPath: parentPath ?? this.parentPath,
    );
  }

  @override
  String get displayRouteName => route.Detail.name;

  @override
  Map<String, String> get routePayload {
    return {
      "parentPath": DocsManager().constructParentPath(this),
    };
  }
}
