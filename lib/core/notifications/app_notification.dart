import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/file_manager/docs_manager.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/notifications/base_notification.dart';
// import 'package:spooky/app.dart';
import 'package:spooky/core/route/router.dart' as route;

class AppNotification extends BaseNotification {
  BuildContext? get context => App.navigatorKey.currentContext;

  @override
  void selectNotification(String? payload) async {
    if (kDebugMode) {
      print("payload: $payload");
      // payload.replaceAll("%2F", replace)

    }
    if (payload != null) {
      Uri? uri = Uri.tryParse(payload);
      String? path = uri?.path.replaceFirst("/", "");
      switch (path) {
        case route.Detail.name:
          if (uri?.queryParameters.containsKey('parentPath') == true) {
            StoryModel? result = await DocsManager().fetchOneByFileParent(uri!.queryParameters['parentPath']!);
            if (result != null && context != null) {
              context!.router.push(
                route.Detail(story: result),
              );
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
