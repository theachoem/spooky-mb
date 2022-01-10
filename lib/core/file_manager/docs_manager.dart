import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:spooky/core/file_manager/base_file_manager.dart';
import 'package:spooky/core/file_manager/base_fm_constructor_mixin.dart';
import 'package:spooky/core/file_manager/story_query_mixin.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';

class DocsManager extends BaseFileManager with StoryQueryMixin {
  @override
  FilePath get parentPathEnum => FilePath.docs;

  /// eg. $appPath/$parentPathStr/2022/Jan/7/
  @override
  String constructParentPath(BaseModel model, [FilePath? customParentPath]) {
    model as StoryModel;
    String? year = model.pathDate?.year.toString();
    String? month = DateFormatHelper.toNameOfMonth().format(model.pathDate!);
    String? day = model.pathDate!.day.toString();
    return [appPath, customParentPath?.name ?? parentPath, year, month, day, model.documentId].join("/");
  }

  int docsCount(int year) {
    Directory root = Directory(rootPath + "/" + "$year");
    if (root.existsSync()) {
      List<FileSystemEntity> result = root.listSync(recursive: true);
      Set<String> docs = {};

      for (FileSystemEntity element in result) {
        String path = element.absolute.path;
        if (path.endsWith("." + AppConstant.documentExstension)) {
          docs.add(path.split("/").reversed.toList()[1]);
        }
      }

      return docs.length;
    }
    return 0;
  }

  Future<List<StoryModel>?> fetchAll({
    required int year,
    required int month,
  }) async {
    return beforeExec<List<StoryModel>>(() async {
      String? monthName = DateFormatHelper.toNameOfMonth().format(DateTime(year, month));
      List<dynamic> path = [
        appPath,
        parentPath,
        year,
        monthName,
      ];

      Directory directory = Directory(path.join("/"));
      bool exists = await directory.exists();
      if (!exists) {
        directory.create(recursive: true);
        return [];
      }

      if (kDebugMode) {
        print("fetchAll: $directory: $exists");
      }

      var result = directory.listSync(recursive: true);
      var stories = entitiesToDocuments(result);
      return stories;
    });
  }

  Future<List<StoryModel>?> fetchChangesHistory({
    required DateTime date,
    required String id,
  }) async {
    return beforeExec<List<StoryModel>>(() async {
      return [];
    });
  }

  @override
  Future<File?> write(BaseModel model) async {
    if (model is StoryModel) {
      if (model.documentId == null) {
        message = MessageSummary("documentId is missing");
        return null;
      }
      if (model.createdAt == null) {
        message = MessageSummary("createdAt is missing");
        return null;
      }
      if (model.pathDate == null) {
        message = MessageSummary("pathDate is missing");
        return null;
      }
    }
    return super.write(model);
  }
}
