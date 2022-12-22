library setting_view;

import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/external_apis/remote_configs/remote_config_keys.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/security/security_service.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/services/toast_service.dart';
import 'package:spooky/providers/developer_mode_provider.dart';
import 'package:spooky/providers/in_app_update_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/views/lock/types/lock_flow_type.dart';
import 'package:spooky/views/setting/local_widgets/in_app_update_button.dart';
import 'package:spooky/views/setting/local_widgets/notification_permission_button.dart';
import 'package:spooky/views/setting/local_widgets/security_question_button.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_app_version.dart';
import 'package:spooky/widgets/sp_developer_visibility.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/setting/setting_view_model.dart';
import 'package:spooky/widgets/sp_remote_config_enabler.dart';
import 'package:spooky/widgets/sp_sections_tiles.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';

part 'setting_mobile.dart';

class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SettingViewModel>(
      create: (BuildContext context) => SettingViewModel(),
      builder: (context, viewModel, child) {
        return _SettingMobile(viewModel);
      },
    );
  }
}
