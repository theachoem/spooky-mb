import 'dart:io';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/backups/providers/dropbox_cloud_provider.dart';
import 'package:spooky/core/models/cloud_file_list_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';
import 'package:spooky/core/backups/models/backups_model.dart';

class DropBoxBackupDestination extends BaseBackupDestination<DropboxCloudProvider> {
  @override
  String get cloudId => "dropbox";

  @override
  Future<CloudFileModel?> backup(FileSystemEntity file, BackupsModel backups) async {
    return null;
  }

  @override
  Future<String?> fetchContent(CloudFileModel file) async {
    return null;
  }

  @override
  Future<CloudFileListModel?> fetchAll({
    Map<String, dynamic> params = const {},
  }) async {
    return null;
  }

  @override
  IconData get iconData => CommunityMaterialIcons.dropbox;
}
