import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/file_managers/types/file_path_type.dart';
import 'package:spooky/core/models/base_model.dart';

part 'path_model.g.dart';

@JsonSerializable()
class PathModel extends BaseModel {
  final String fileName;
  final int year;
  final int month;
  final int day;
  final FilePathType filePath;

  PathModel({
    required this.fileName,
    required this.year,
    required this.month,
    required this.day,
    required this.filePath,
  });

  PathModel.fromDateTime(DateTime date)
      : fileName = date.millisecondsSinceEpoch.toString() + ".json",
        year = date.year,
        month = date.month,
        day = date.day,
        filePath = FilePathType.docs;

  String toPath() {
    return [
      filePath.name,
      year,
      month,
      day,
      fileName,
    ].join("/");
  }

  // File toFile() {
  //   return File("path");
  // }

  @override
  String? get objectId => fileName;

  @override
  Map<String, dynamic> toJson() => _$PathModelToJson(this);
  factory PathModel.fromJson(Map<String, dynamic> json) => _$PathModelFromJson(json);
}
