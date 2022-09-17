import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/theme/theme_config.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart' as dn;
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/utils/util_widgets/sp_date_picker.dart';

class SpStoryTileUtils {
  final StoryDbModel Function() story;
  final BuildContext context;
  final Future<void> Function() reloadList;
  final Future<void> Function() reloadStory;
  final Future<void> Function() beforeAction;
  final void Function(StoryDbModel story, bool reloadState, bool saveToCache) setStory;
  late final StoryDatabase database;

  SpStoryTileUtils({
    required this.story,
    required this.context,
    required this.reloadList,
    required this.reloadStory,
    required this.beforeAction,
    required this.setStory,
  }) {
    database = StoryDatabase.instance;
  }

  Future<bool> refreshSuccess(
    Future<bool> Function() callback, {
    required bool refreshList,
    required bool refreshStory,
  }) async {
    await beforeAction();
    bool success = await callback();
    if (success && refreshList) await reloadList();
    if (success && refreshStory) await reloadStory();
    return success;
  }

  Future<bool> changeStoryDate() async {
    DateTime? pathDate = await SpDatePicker.showDatePicker(
      context,
      story().displayPathDate,
    );

    if (pathDate != null) {
      StoryDbModel updatedStory = story().copyWith(
        year: pathDate.year,
        month: pathDate.month,
        day: pathDate.day,
        hour: story().displayPathDate.hour,
        minute: story().displayPathDate.minute,
      );

      setStory(updatedStory, true, true);

      StoryDbModel? result = await database.update(id: updatedStory.id, body: updatedStory);
      if (result != null) setStory(result, true, true);

      return database.error == null;
    }

    return false;
  }

  Future<bool> changeStoryTime() async {
    TimeOfDay? time;

    await Navigator.of(context).push(
      dn.showPicker(
        context: context,
        value: TimeOfDay.fromDateTime(story().displayPathDate),
        cancelText: MaterialLocalizations.of(context).cancelButtonLabel,
        okText: MaterialLocalizations.of(context).okButtonLabel,
        // iosStylePicker: ThemeConfig.isApple(Theme.of(context).platform),
        okStyle: TextStyle(fontFamily: M3TextTheme.of(context).labelLarge?.fontFamily),
        cancelStyle: TextStyle(fontFamily: M3TextTheme.of(context).labelLarge?.fontFamily),
        buttonStyle: ThemeConfig.isApple(Theme.of(context).platform)
            ? ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent))
            : null,
        onCancel: () {
          Navigator.of(context).pop();
        },
        onChangeDateTime: (date) => time = TimeOfDay.fromDateTime(date),
        onChange: (t) => time = t,
      ),
    );

    if (time != null) {
      StoryDbModel updatedStory = story().copyWith(hour: time?.hour, minute: time?.minute);
      setStory(updatedStory, true, true);

      StoryDbModel? result = await database.update(id: updatedStory.id, body: updatedStory);
      if (result != null) setStory(result, true, true);

      return result != null;
    }

    return false;
  }

  Future<bool> archiveStory() async {
    String title, message, label;

    title = tr("alert.are_you_sure_to_archive.title");
    message = tr("alert.are_you_sure_to_archive.message");
    label = tr("button.archive");

    OkCancelResult result = await showOkCancelAlertDialog(
      context: context,
      title: title,
      message: message,
      okLabel: label,
      cancelLabel: tr("button.cancel"),
    );

    switch (result) {
      case OkCancelResult.ok:
        await database.archiveDocument(story());
        bool success = database.error == null;
        String message = success ? tr("msg.archive.success") : tr("msg.archive.fail");
        MessengerService.instance.showSnackBar(message, success: success);
        return success;
      case OkCancelResult.cancel:
        return false;
    }
  }

  Future<bool> putBackStory() async {
    String? date = DateFormatHelper.yM().format(story().displayPathDate);
    String title, message, label;

    title = tr("alert.are_you_sure_to_put_back.title");
    message = "${tr("alert.are_you_sure_to_put_back.message_")}\n$date";
    label = tr("button.put_back");

    OkCancelResult result = await showOkCancelAlertDialog(
      context: context,
      title: title,
      message: message,
      okLabel: label,
      cancelLabel: tr("button.cancel"),
    );

    switch (result) {
      case OkCancelResult.ok:
        await database.putBackToDocs(story());
        bool success = database.error == null;
        String message = success ? tr("msg.put_back.success") : tr("msg.put_back.fail");
        MessengerService.instance.showSnackBar(message, success: success);
        return success;
      case OkCancelResult.cancel:
        return false;
    }
  }

  Future<bool> deleteStory() async {
    OkCancelResult result;

    switch (story().type) {
      case PathType.docs:
      case PathType.archives:
        result = await showOkCancelAlertDialog(
          context: context,
          title: tr("msg.move_to_bin.title"),
          message: tr("msg.move_to_bin.message", args: [AppConstant.deleteInDuration.inDays.toString()]),
          okLabel: tr("button.move_to_bin"),
          isDestructiveAction: true,
          cancelLabel: tr("button.cancel"),
        );

        switch (result) {
          case OkCancelResult.ok:
            await database.moveToTrash(story());
            bool success = database.error == null;
            String message = success ? tr("msg.move_to_bin.success") : tr("msg.move_to_bin.fail");
            MessengerService.instance.showSnackBar(message, success: success);
            return success;
          case OkCancelResult.cancel:
            return false;
        }
      case PathType.bins:
        result = await showOkCancelAlertDialog(
          context: context,
          title: tr("alert.are_you_sure_to_delete.title"),
          message: tr("alert.are_you_sure_to_delete.message"),
          okLabel: tr("button.perminent_delete"),
          isDestructiveAction: true,
          cancelLabel: tr("button.cancel"),
        );
        switch (result) {
          case OkCancelResult.ok:
            await database.deleteDocument(story());
            bool success = database.error == null;
            String message = success ? tr("msg.perminent_delete.success") : tr("msg.perminent_delete.fail");
            MessengerService.instance.showSnackBar(message, success: success, action: (foreground) {
              return SnackBarAction(
                // ignore: use_build_context_synchronously
                label: tr("button.undo"),
                textColor: foreground,
                onPressed: () async {
                  await database.create(body: story());
                  reloadList();
                },
              );
            });
            return success;
          case OkCancelResult.cancel:
            return false;
        }
    }
  }
}
