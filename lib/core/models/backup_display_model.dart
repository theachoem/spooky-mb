import 'package:flutter/foundation.dart';
import 'package:spooky/core/models/cloud_file_model.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';

class BackupDisplayModel {
  final String fileName;
  final DateTime? createAt;
  BackupDisplayModel(this.fileName, this.createAt);

  String? get displayCreateAt {
    if (createAt != null) {
      return DateFormatHelper.dateTimeFormat().format(createAt!);
    } else {
      return null;
    }
  }

  factory BackupDisplayModel.fromCloudModel(CloudFileModel file) {
    String fileName = file.description ?? file.fileName ?? file.id;

    String? year;
    DateTime? createAt;

    try {
      String removedExt = fileName.replaceAll(".json", "");
      List<String> splitted = removedExt.split("_");
      if (splitted.length == 2) {
        year = int.parse(splitted[0]).toString();
        createAt = DateTime.parse(splitted[1]);
      }
    } catch (e) {
      if (kDebugMode) {
        print("ERROR: $e");
      }
    }

    return BackupDisplayModel(year ?? fileName, createAt);
  }
}
