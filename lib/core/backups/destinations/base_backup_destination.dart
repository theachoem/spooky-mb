import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/backups/models/backups_model.dart';
import 'package:spooky/core/backups/providers/base_cloud_provider.dart';
import 'package:spooky/core/models/cloud_file_list_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';

abstract class BaseBackupDestination<T extends BaseCloudProvider> {
  CloudFileListModel? cloudFiles;

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

  Widget buildWithConsumer({
    required Widget Function(BuildContext context, T value, Widget? child) builder,
    Widget? child,
  }) {
    return Consumer<T>(
      builder: builder,
      child: child,
    );
  }

  IconData get iconData;
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
