import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:spooky/core/backups/models/backups_model.dart';
import 'package:spooky/core/models/cloud_file_list_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';

abstract class BaseBackupDestination {
  String get cloudId;
  Future<CloudFileModel?> backup(FileSystemEntity file, BackupsModel backups);

  Future<CloudFileListModel?> fetchAll({
    Map<String, dynamic> params = const {},
  });

  /// only call from base class
  Future<String?> fetchContent(CloudFileModel file);

  Future<BackupsModel?> download(CloudFileModel file) async {
    String? content = await fetchContent(file);
    if (content != null) return fromJson(content);
    return null;
  }

  Future<BackupsModel?> fromJson(String content) async {
    BackupsModel? backups = await compute(_fromJson, content);
    return backups;
  }
}

BackupsModel? _fromJson(String content) {
  try {
    dynamic map = jsonDecode(content);
    if (map is Map<String, dynamic> && map.containsKey('version')) {
      return BackupsModel.fromJson(map);
    }
  } catch (e) {
    if (kDebugMode) print("ERROR: _fromJson $e");
  }
  return null;
}
