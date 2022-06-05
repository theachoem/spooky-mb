import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/types/file_path_type.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

part 'path_model.g.dart';

@Deprecated("Don't use anymore")
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

  PathModel copyWith({
    String? fileName,
    int? year,
    int? month,
    int? day,
    FilePathType? filePath,
  }) {
    return PathModel(
      fileName: fileName ?? this.fileName,
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      filePath: filePath ?? this.filePath,
    );
  }

  PathModel.fromDateTime(DateTime date)
      : fileName = "${date.millisecondsSinceEpoch}.json",
        year = date.year,
        month = date.month,
        day = date.day,
        filePath = FilePathType.docs;

  DateTime toDateTime() {
    return DateTime(year, month, day);
  }

  bool sameDayAs(PathModel compare) {
    String thisOne = [year, month, day].join("/");
    String compareTo = [compare.year, compare.month, compare.day].join("/");
    return thisOne == compareTo;
  }

  String toPath() {
    return [
      filePath.name,
      year,
      month,
      day,
      fileName,
    ].join("/");
  }

  String toFullPath() {
    return [
      FileHelper.directory.absolute.path,
      toPath(),
    ].join("/");
  }

  File toFile() {
    return File(toFullPath());
  }

  @override
  String? get objectId => fileName;

  @override
  Map<String, dynamic> toJson() => _$PathModelToJson(this);
  factory PathModel.fromJson(Map<String, dynamic> json) => _$PathModelFromJson(json);
}
