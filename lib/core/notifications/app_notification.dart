import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/file_manager/docs_manager.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/notifications/base_notification.dart';
// import 'package:spooky/app.dart';
import 'package:spooky/core/route/router.dart' as route;
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
        case route.Detail.name:
          if (context!.router.current.name == path) {
            if (uri?.queryParameters.containsKey('parentPath') == true) {
              StoryModel? result = await DocsManager().fetchOneByFileParent(uri!.queryParameters['parentPath']!);
              if (result != null) {
                String? message;
                if (result.pathDate != null || result.createdAt != null) {
                  message = DateFormatHelper.yM().format(result.pathDate ?? result.createdAt!);
                }
                showOkAlertDialog(
                  context: context!,
                  title: "Your document is saved",
                  message: message != null ? "Document will be move to:\n" + message : null,
                );
              }
            }
          }
          break;
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
}
