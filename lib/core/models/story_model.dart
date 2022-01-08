import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/ui/views/detail/detail_view_model.dart';

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
    );
  }
}
