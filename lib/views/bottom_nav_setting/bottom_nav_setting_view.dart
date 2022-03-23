library bottom_nav_setting_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'bottom_nav_setting_view_model.dart';

part 'bottom_nav_setting_mobile.dart';
part 'bottom_nav_setting_tablet.dart';
part 'bottom_nav_setting_desktop.dart';

class BottomNavSettingView extends StatelessWidget {
  const BottomNavSettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BottomNavSettingViewModel>(
      create: (context) => BottomNavSettingViewModel(),
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _BottomNavSettingMobile(viewModel),
          desktop: _BottomNavSettingDesktop(viewModel),
          tablet: _BottomNavSettingTablet(viewModel),
        );
      },
    );
  }
}
