import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/notification/channels/base_notification_channel.dart';
import 'package:spooky/core/types/notification_channel_types.dart';
import 'package:spooky/core/notification/payloads/auto_save_payload.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';

export 'package:spooky/core/notification/payloads/auto_save_payload.dart';

class AutoSaveChannel extends BaseNotificationChannel<AutoSavePayload> {
  @override
  NotificationChannelTypes get channelKey => NotificationChannelTypes.autoSave;

  @override
  bool get enableVibration => true;

  @override
  String get channelName => 'Auto Save Notification';

  @override
  String get channelDescription => 'Show notification when stories is auto saved on app inactive.';

  @override
  String? get icon => "ni_auto_save";

  @override
  List<NotificationActionButton>? get actionButtons => null;

  @override
  bool get singleInstance => false;

  @override
  Future<void> triggered({
    String? buttonKey,
    Map<String, String?>? payload,
  }) async {
    if (payload == null) return;
    AutoSavePayload? object;

    try {
      object = AutoSavePayload.fromJson(payload);
    } catch (e) {
      if (kDebugMode) {
        print("ERROR: AutoSaveChannel#triggered $e");
        rethrow;
      }
    }

    int? id = int.tryParse(object?.id ?? "");
    if (id == null) return;

    StoryDbModel? story = await StoryDatabase.instance.fetchOne(id: id);
    if (story == null) return;

    String? message;
    if (story.changes.isNotEmpty) {
      message = DateFormatHelper.yM().format(story.changes.last.createdAt);
    }

    if (context == null) return;
    showOkAlertDialog(
      context: context!,
      title: "Your document is saved",
      message: message != null ? "Document is saved in\n$message" : null,
    );
  }
}
