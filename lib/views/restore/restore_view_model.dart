import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spooky/core/api/authentication/google_auth_service.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/cloud_storages/gdrive_backup_storage.dart';
import 'package:spooky/core/file_manager/managers/story_manager.dart';
import 'package:spooky/core/models/backup_model.dart';
import 'package:spooky/core/models/cloud_file_list_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/services/messenger_service.dart';

class RestoreViewModel extends BaseViewModel {
  final GoogleAuthService googleAuth = GoogleAuthService.instance;
  GoogleSignInAccount? googleUser;

  CloudFileListModel? fileList;
  RestoreViewModel() {
    load();
  }

  Future<void> load() async {
    await loadAuthentication();
    GDriveBackupStorage storage = GDriveBackupStorage();
    fileList = await storage.execHandler(() => storage.list({"next_token": fileList?.nextToken}));
    notifyListeners();
  }

  Future<void> loadAuthentication() async {
    await googleAuth.googleSignIn.isSignedIn().then((signedIn) async {
      if (signedIn) {
        await googleAuth.signInSilently();
        googleUser = googleAuth.googleSignIn.currentUser;
      }
    });
  }

  Future<void> signInWithGoogle() async {
    await googleAuth.signIn();
    load();
  }

  Map<String, BackupModel> cacheDownloadRestores = {};
  Future<BackupModel?> download(CloudFileModel file) async {
    if (cacheDownloadRestores.containsKey(file.id)) {
      return cacheDownloadRestores[file.id]!;
    } else {
      GDriveBackupStorage storage = GDriveBackupStorage();
      String? content = await storage.get({"file": file});
      if (content != null) {
        dynamic map = jsonDecode(content);
        BackupModel backup = BackupModel.fromJson(map);
        cacheDownloadRestores[file.id] = backup;
        return backup;
      }
    }
    return null;
  }

  Future<bool> restore(BuildContext context, CloudFileModel file) async {
    BackupModel? backup = await MessengerService.instance.showLoading(future: () => download(file), context: context);
    if (backup != null) {
      for (StoryModel e in backup.stories) {
        await StoryManager().write(e.path.toFile(), e);
      }
    }
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      MessengerService.instance.showSnackBar("Restored");
    });

    return true;
  }
}
