import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
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
  String get channelName => tr("notification_channel.auto_save.name");

  @override
  String get channelDescription => tr("notification_channel.auto_save.description");

  @override
  String? get icon => "ni_auto_save";

  @override
  List<NotificationActionButton>? get actionButtons => null;

  @override
  bool get singleInstance => true;

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
      title: tr("alert.document_saved.title"),
      okLabel: tr("button.ok"),
      message: message != null ? "${tr("alert.document_saved.subtitle")}\n$message" : null,
    );
  }
}
