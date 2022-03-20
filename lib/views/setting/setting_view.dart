library setting_view;

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/types/product_as_type.dart';
import 'package:spooky/providers/user_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/widgets/sp_app_version.dart';
import 'package:spooky/widgets/sp_developer_visibility.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/setting/setting_view_model.dart';
import 'package:spooky/widgets/sp_about.dart' as about;
import 'package:spooky/widgets/sp_sections_tiles.dart';

part 'setting_mobile.dart';
part 'setting_tablet.dart';
part 'setting_desktop.dart';

class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SettingViewModel>(
      create: (BuildContext context) => SettingViewModel(),
      builder: (context, viewModel, child) {
        return SpScreenTypeLayout(
          mobile: _SettingMobile(viewModel),
          desktop: _SettingDesktop(viewModel),
          tablet: _SettingTablet(viewModel),
        );
      },
    );
  }
}
