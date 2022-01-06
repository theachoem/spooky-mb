import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/base_model.dart';

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

  // Returns JSON-serializable version of quill delta.
  final List<dynamic>? document;

  StoryModel({
    required this.documentId,
    required this.fileId,
    required this.starred,
    required this.feeling,
    required this.title,
    required this.createdAt,
    required this.plainText,
    required this.document,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) => _$StoryModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StoryModelToJson(this);

  @override
  String? get objectId => fileId;

  static List<String> get excludeCompareKeys {
    return [
      'document_id',
      'file_id',
      'created_at',
    ];
  }

  static String keepComparableKeys(StoryModel model) {
    Map<String, dynamic> json = model.toJson();
    json.removeWhere((key, value) {
      return excludeCompareKeys.contains(key);
    });
    return jsonEncode(json);
  }

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
    DateTime? updatedAt,
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
      plainText: plainText ?? this.plainText,
      document: document ?? this.document,
    );
  }
}
