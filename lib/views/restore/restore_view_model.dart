import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
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
  // RestoreViewModel() {}

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

  Future<void> restore(BuildContext context, CloudFileModel file) async {
    MessengerService.instance.showSnackBar("Loading");

    GDriveBackupStorage storage = GDriveBackupStorage();
    String? content = await storage.get({"file": file});
    if (content != null) {
      dynamic map = jsonDecode(content);
      BackupModel backup = BackupModel.fromJson(map);
      for (StoryModel e in backup.stories) {
        await StoryManager().write(e.path.toFile(), e);
      }
    }

    MessengerService.instance.showSnackBar("Synced");
  }
}
