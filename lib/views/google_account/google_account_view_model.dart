import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spooky/core/api/authentication/google_auth_service.dart';
import 'package:spooky/core/api/services/google_drive_service.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/models/story_model.dart';

class GoogleAccountViewModel extends BaseViewModel {
  GoogleSignInAccount? get currentUser => service.googleSignIn.currentUser;

  final GoogleAuthService service = GoogleAuthService.instance;
  final GoogleDriveService driveService = GoogleDriveService();

  List<StoryModel> stories = [];

  GoogleAccountViewModel() {
    authenticate();
    load();
  }

  Future<void> load() async {
    List<StoryModel> _stories = [];
    drive.FileList? fileList = await driveService.fetchAll();
    if (fileList != null) {
      var first = fileList.files?.first;
      if (first != null) {
        String? result = await driveService.fetchOne(first);
        if (result != null) {
          var json = jsonDecode(result);
          _stories.add(StoryModel.fromJson(json));
        }
      }
    }
    stories = _stories;
    notifyListeners();
  }

  Future<void> authenticate() async {
    bool signIn = await service.googleSignIn.isSignedIn();
    if (signIn) {
      await service.signInSilently();
      notifyListeners();
    }
  }

  Future<void> signIn() async {
    bool signIn = await service.googleSignIn.isSignedIn();
    if (!signIn) {
      await service.signIn();
      notifyListeners();
    }
  }

  Future<void> logOut() async {
    bool signIn = await service.googleSignIn.isSignedIn();
    if (signIn) {
      await service.googleSignIn.signOut();
      notifyListeners();
    }
  }

  Future<void> upload(StoryModel e) async {
    var result = await driveService.write(e.file!);
    if (kDebugMode) {
      print("RESU: ${result?.id}");
      print(result?.toJson());
    }
  }
}
