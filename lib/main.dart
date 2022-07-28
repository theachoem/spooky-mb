import 'dart:io';
import 'package:desktop_window/desktop_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/db/adapters/base/base_objectbox_adapter.dart';
import 'package:spooky/core/db/databases/tag_database.dart';
import 'package:spooky/core/db/models/tag_db_model.dart';
import 'package:spooky/core/notification/notification_service.dart';
import 'package:spooky/core/services/initial_tab_service.dart';
import 'package:spooky/core/storages/local_storages/nickname_storage.dart';
import 'package:spooky/core/storages/local_storages/purchased_add_on_storage.dart';
import 'package:spooky/core/storages/local_storages/sp_list_layout_type_storage.dart';
import 'package:spooky/flavor_config.dart';
import 'package:spooky/initial_theme.dart';
import 'package:spooky/provider_scope.dart';
import 'package:spooky/providers/theme_provider.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:spooky/utils/helpers/file_helper.dart';
import 'package:spooky/widgets/sp_list_layout_builder.dart';
import 'package:spooky/widgets/sp_story_list/sp_story_list.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'package:spooky/firebase_options.dart';
// import 'package:spooky/utils/helpers/debug_error_exception.dart';

part 'global.dart';
part 'initializer.dart';

void main() async {
  await _Initializer.load();
  runApp(
    Phoenix(
      child: EasyLocalization(
        supportedLocales: AppConstant.supportedLocales,
        fallbackLocale: AppConstant.fallbackLocale,
        path: 'assets/translations',
        child: ProviderScope(
          child: InitialTheme(
            child: App(),
          ),
        ),
      ),
    ),
  );
}
