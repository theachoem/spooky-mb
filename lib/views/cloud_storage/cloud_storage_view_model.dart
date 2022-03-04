import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spooky/core/api/authentication/google_auth_service.dart';
import 'package:spooky/core/backup/backup_constructor.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/cloud_storages/gdrive_backup_storage.dart';
import 'package:spooky/core/file_manager/managers/backup_file_manager.dart';
import 'package:spooky/core/file_manager/managers/story_manager.dart';
import 'package:spooky/core/models/backup_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';

class YearCloudModel {
  final int year;
  final bool synced;

  YearCloudModel({
    required this.year,
    required this.synced,
  });
}

class CloudStorageViewModel extends BaseViewModel {
  final GoogleAuthService googleAuth = GoogleAuthService.instance;
  final BackupFileManager backupFileManager = BackupFileManager();
  final GDriveBackupStorage gDriveBackupStorage = GDriveBackupStorage();
  final StoryManager storyManager = StoryManager();
  Set<int> loadingYears = {};

  void turnOnLoading(int year) {
    loadingYears.add(year);
    notifyListeners();
  }

  void turnOffLoading(int year) {
    loadingYears.remove(year);
    notifyListeners();
  }

  GoogleSignInAccount? googleUser;
  List<YearCloudModel>? years;

  CloudStorageViewModel() {
    load();
  }

  Future<void> load() async {
    await loadYears();
    await loadAuthentication();
    notifyListeners();
  }

  Future<void> loadYears() async {
    List<YearCloudModel> _years = [];
    Set<int>? intYears = await storyManager.fetchYears();
    List<BackupModel>? backups = await backupFileManager.fetchAll();
    List<int> syncedYears = backups.map((e) => e.year).toList();

    if (intYears != null) {
      for (int y in intYears) {
        _years.add(
          YearCloudModel(
            year: y,
            synced: syncedYears.contains(y),
          ),
        );
      }
      years = _years;
    }
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

  Future<void> backup(int year) async {
    turnOnLoading(year);
    final backupConstructor = BackupConstructor();
    BackupModel? backup = await backupConstructor.generateBackupsForAYears(year);
    if (backup != null) {
      FileSystemEntity? file = await backupFileManager.backup(backup);
      if (file != null) {
        CloudFileModel? cloudFile = await gDriveBackupStorage.write({
          "file": file,
          "backup": backup,
        });
        bool success = cloudFile != null;
        if (!success) {
          await file.delete();
        }
      }
    }
    await loadYears();
    turnOffLoading(year);
  }
}
