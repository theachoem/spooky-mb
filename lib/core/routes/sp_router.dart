import 'package:spooky/core/models/cloud_file_model.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/backups/destinations/cloud_file_tuple.dart';
import 'package:spooky/core/backups/providers/base_cloud_provider.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/views/lock/types/lock_flow_type.dart';

export 'sp_route_extension.dart';
part 'app_router.gr.dart';

enum SpRouter {
  home,
  backupsDetails,
  cloudStorages,
  fontManager,
  lock,
  security,
  themeSetting,
  managePages,
  archive,
  contentReader,
  changesHistory,
  detail,
  main,
  explore,
  appStarter,
  initPickColor,
  nicknameCreator,
  developerMode,
  addOn,
  soundList,
  bottomNavSetting,
  notFound,
  setting,
  storyPadRestore,
  user,
  signUp,
  search,
  backupHistoriesManager,
  accountDeletion,
  tags,
}
