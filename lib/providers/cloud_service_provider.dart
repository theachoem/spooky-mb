import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spooky/core/api/authentication/google_auth_service.dart';
import 'package:spooky/core/storages/local_storages/spooky_drive_folder_id_storage.dart';

class CloudServiceProvider extends ChangeNotifier {
  final GoogleAuthService googleAuth = GoogleAuthService.instance;
  GoogleSignInAccount? googleUser;
  String? driveFolderId;

  CloudServiceProvider() {
    load();
  }

  Future<void> load() async {
    driveFolderId = await SpookyDriveFolderStorageIdStorage().read();
    await loadAuthentication();
    notifyListeners();
  }

  Future<void> loadAuthentication() async {
    await googleAuth.googleSignIn.isSignedIn().then((signedIn) async {
      if (signedIn) {
        await googleAuth.signInSilently();
        googleUser = googleAuth.googleSignIn.currentUser;
      } else {
        googleUser = null;
      }
    });
  }

  Future<void> signInWithGoogle() async {
    await googleAuth.signIn();
    load();
  }

  Future<void> signOutOfGoogle() async {
    await googleAuth.signOut();
    await load();
  }
}
