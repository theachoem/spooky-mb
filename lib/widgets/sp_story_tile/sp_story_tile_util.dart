import 'package:adaptive_dialog/adaptive_dialog.dart';
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
  final StoryDbModel story;
  final BuildContext context;
  final Future<void> Function() reloadList;
  final Future<void> Function() reloadStory;
  late final StoryDatabase database;

  SpStoryTileUtils({
    required this.story,
    required this.context,
    required this.reloadList,
    required this.reloadStory,
  }) {
    database = StoryDatabase.instance;
  }

  Future<bool> refreshSuccess(
    Future<bool> Function() callback, {
    bool refreshList = true,
    bool refreshStory = false,
  }) async {
    bool success = await callback();
    if (success && refreshList) await reloadList();
    if (success && refreshStory) await reloadList();
    return success;
  }

  Future<bool> changeStoryDate() async {
    DateTime? pathDate = await SpDatePicker.showDatePicker(
      context,
      story.displayPathDate,
    );

    if (pathDate != null) {
      await database.updatePathDate(story, pathDate);
      return database.error == null;
    }

    return false;
  }

  Future<bool> changeStoryTime() async {
    TimeOfDay? time;

    await Navigator.of(context).push(
      dn.showPicker(
        context: context,
        value: TimeOfDay.fromDateTime(story.displayPathDate),
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
      StoryDbModel? result = await database.updatePathTime(story, time!);
      return result != null;
    }

    return false;
  }

  Future<bool> archiveStory() async {
    String title, message, label;

    title = "Are you sure to archive?";
    message = "You can unarchive later.";
    label = "Archive";

    OkCancelResult result = await showOkCancelAlertDialog(
      context: context,
      title: title,
      message: message,
      okLabel: label,
    );

    switch (result) {
      case OkCancelResult.ok:
        await database.archiveDocument(story);
        bool success = database.error == null;
        String message = success ? "Successfully!" : "Unsuccessfully!";
        MessengerService.instance.showSnackBar(message, success: success);
        return success;
      case OkCancelResult.cancel:
        return false;
    }
  }

  Future<bool> putBackStory() async {
    String? date = DateFormatHelper.yM().format(story.displayPathDate);
    String title, message, label;

    title = "Are you sure put back?";
    message = "Document will be move to:\n$date";
    label = "Put back";

    OkCancelResult result = await showOkCancelAlertDialog(
      context: context,
      title: title,
      message: message,
      okLabel: label,
    );

    switch (result) {
      case OkCancelResult.ok:
        await database.putBackToDocs(story);
        bool success = database.error == null;
        String message = success ? "Successfully!" : "Unsuccessfully!";
        MessengerService.instance.showSnackBar(message, success: success);
        return success;
      case OkCancelResult.cancel:
        return false;
    }
  }

  Future<bool> deleteStory() async {
    OkCancelResult result;

    switch (story.type) {
      case PathType.docs:
      case PathType.archives:
        result = await showOkCancelAlertDialog(
          context: context,
          title: "Move to Bin",
          message: "You story will be deleted in ${AppConstant.deleteInDuration.inDays} days.",
          okLabel: "Move to Bin",
          isDestructiveAction: true,
        );

        switch (result) {
          case OkCancelResult.ok:
            await database.moveToTrash(story);
            bool success = database.error == null;
            String message = success ? "Moved to bin" : "Move unsuccessfully!";
            MessengerService.instance.showSnackBar(message, success: success);
            return success;
          case OkCancelResult.cancel:
            return false;
        }
      case PathType.bins:
        result = await showOkCancelAlertDialog(
          context: context,
          title: "Are you sure to delete?",
          message: "You can't undo this action",
          okLabel: "Delete Forever",
          isDestructiveAction: true,
        );
        switch (result) {
          case OkCancelResult.ok:
            await database.deleteDocument(story);
            bool success = database.error == null;
            String message = success ? "Delete successfully!" : "Delete unsuccessfully!";
            MessengerService.instance.showSnackBar(message, success: success, action: (foreground) {
              return SnackBarAction(
                // ignore: use_build_context_synchronously
                label: "Undo",
                textColor: foreground,
                onPressed: () async {
                  await database.create(body: story);
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
