import 'dart:io';
import 'package:desktop_window/desktop_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/backups/providers/google_cloud_provider.dart';
import 'package:spooky/core/db/adapters/base/base_objectbox_adapter.dart';
import 'package:spooky/core/external_apis/remote_configs/remote_config_service.dart';
import 'package:spooky/core/notification/notification_service.dart';
import 'package:spooky/core/services/google_font_cache_clearer.dart';
import 'package:spooky/core/services/initial_tab_service.dart';
import 'package:spooky/core/services/story_tags_service.dart';
import 'package:spooky/core/storages/local_storages/nickname_storage.dart';
import 'package:spooky/core/storages/local_storages/purchased_add_on_storage.dart';
import 'package:spooky/core/storages/local_storages/sp_list_layout_type_storage.dart';
import 'package:spooky/flavor_config.dart';
import 'package:spooky/initial_theme.dart';
import 'package:spooky/provider_scope.dart';
import 'package:spooky/providers/in_app_update_provider.dart';
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
part 'app_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await _Initializer.load();

  runApp(
    Phoenix(
      child: const AppLocalization(
        child: ProviderScope(
          child: InitialTheme(
            child: App(),
          ),
        ),
      ),
    ),
  );
}
