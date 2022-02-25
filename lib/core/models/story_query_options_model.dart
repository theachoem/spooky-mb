import 'package:spooky/core/types/file_path_type.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

class StoryQueryOptionsModel {
  final int? year;
  final int? month;
  final int? day;
  final FilePathType filePath;

  StoryQueryOptionsModel({
    this.year,
    this.month,
    this.day,
    required this.filePath,
  });

  // docs/2021/1/12
  String toPath([String? parent]) {
    List<String> paths = [
      parent ?? FileHelper.directory.absolute.path,
      filePath.name,
      if (year != null) "$year",
      if (month != null) "$month",
      if (day != null) "$day",
    ];
    return paths.join("/");
  }
}
