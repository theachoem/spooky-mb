import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:spooky/core/file_manager/base_file_manager.dart';
import 'package:spooky/core/file_manager/base_fm_constructor_mixin.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';

class DocsManager extends BaseFileManager {
  @override
  FilePath get parentPathEnum => FilePath.docs;

  /// eg. $appPath/$parentPathStr/2022/Jan/7/
  @override
  String constructParentPath(BaseModel model) {
    model as StoryModel;
    String? year = model.pathDate?.year.toString();
    String? month = DateFormatHelper.toNameOfMonth().format(model.pathDate!);
    String? day = model.pathDate!.day.toString();
    return [appPath, parentPath, year, month, day, model.documentId].join("/");
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

      //
      // {
      //   "7/1641494022922": "1641494022922.json"
      //   "7/1641492326066": "1641492450608.json"
      // }
      Map<String, String> storiesPath = {};

      for (FileSystemEntity e in result) {
        List<String> base = e.absolute.path.replaceFirst(directory.absolute.path + "/", "").split("/");
        if (base.length >= 3 && base[2].endsWith(".json")) {
          String key = base[0] + "/" + base[1];

          // override if base[2] is newer than storiesPath[key]
          if (storiesPath.containsKey(key)) {
            if (storiesPath[key]?.compareTo(base[2]) == -1) {
              storiesPath[key] = base[2];
            }
          } else {
            storiesPath[key] = base[2];
          }
        }
      }

      List<StoryModel> stories = [];

      for (MapEntry<String, String> e in storiesPath.entries) {
        File file = File(directory.absolute.path + "/" + e.key + "/" + e.value);
        StoryModel? story = await fetchOne(file);
        if (story != null) {
          stories.add(story);
        }
      }

      return stories;
    });
  }

  Future<StoryModel?> fetchOne(File file) async {
    String result = await file.readAsString();
    dynamic json = jsonDecode(result);
    if (json is Map<String, dynamic>) {
      StoryModel story = StoryModel.fromJson(json);
      return story;
    }
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
  Future<void> write(BaseModel model) async {
    if (model is StoryModel) {
      if (model.documentId == null) {
        message = MessageSummary("documentId is missing");
        return;
      }
      if (model.createdAt == null) {
        message = MessageSummary("createdAt is missing");
        return;
      }
      if (model.pathDate == null) {
        message = MessageSummary("pathDate is missing");
        return;
      }
    }
    return super.write(model);
  }
}
