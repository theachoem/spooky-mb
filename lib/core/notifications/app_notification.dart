import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/file_managers/story_file_manager.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/notifications/base_notification.dart';
import 'package:spooky/core/route/sp_route_config.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';

class AppNotification extends BaseNotification {
  BuildContext? get context => App.navigatorKey.currentContext;

  @override
  void selectNotification(String? payload) async {
    if (kDebugMode) {
      print("payload: $payload");
    }

    if (payload != null && context != null) {
      Uri? uri = Uri.tryParse(payload);
      String? path = uri?.path.replaceFirst("/", "");
      switch (path) {
        case Detail.name:
          return await onAutosaved(uri);
        default:
      }
    }
  }

  @override
  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    if (kDebugMode) {
      print("id: $id");
      print("title: $title");
      print("body: $body");
      print("payload: $payload");
    }
  }

  Future<void> onAutosaved(Uri? uri) async {
    if (uri?.queryParameters.containsKey('path') == true) {
      String? path = uri?.queryParameters['path'];
      if (path == null) return;

      File file = File(StoryFileManager().appPath + "/" + path);
      if (!file.existsSync()) return;

      StoryModel? result = await StoryFileManager().fetchOne(file);
      if (result == null) return;

      String? message;
      if (result.changes.isNotEmpty) {
        message = DateFormatHelper.yM().format(result.changes.last.createdAt);
      }

      showOkAlertDialog(
        context: context!,
        title: "Your document is saved",
        message: message != null ? "Document will be move to:\n" + message : null,
      );
    }
  }
}
