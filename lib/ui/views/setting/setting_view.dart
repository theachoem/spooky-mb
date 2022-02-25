library setting_view;

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/ui/views/developer_mode/developer_mode_view.dart';
import 'package:spooky/ui/widgets/sp_app_version.dart';
import 'package:spooky/ui/widgets/sp_developer_visibility.dart';
import 'package:spooky/ui/widgets/sp_screen_type_layout.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:stacked/stacked.dart';
import 'package:spooky/ui/views/setting/setting_view_model.dart';
import 'package:spooky/ui/widgets/sp_about.dart' as about;

part 'setting_mobile.dart';
part 'setting_tablet.dart';
part 'setting_desktop.dart';

class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return SpScreenTypeLayout(
          mobile: _SettingMobile(model),
          desktop: _SettingDesktop(model),
          tablet: _SettingTablet(model),
        );
      },
    );
  }
}
