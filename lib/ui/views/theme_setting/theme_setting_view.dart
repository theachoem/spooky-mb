library theme_setting_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/app.dart';
import 'package:spooky/initial_theme.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/ui/widgets/sp_color_picker.dart';
import 'package:spooky/ui/widgets/sp_cross_fade.dart';
import 'package:spooky/ui/widgets/sp_overlay_popup_button.dart';
import 'package:spooky/ui/widgets/sp_pop_button.dart';
import 'package:spooky/ui/widgets/sp_theme_switcher.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/extensions/string_extension.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'theme_setting_view_model.dart';

part 'theme_setting_mobile.dart';
part 'theme_setting_tablet.dart';
part 'theme_setting_desktop.dart';

class ThemeSettingView extends StatelessWidget {
  const ThemeSettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ThemeSettingViewModel>.reactive(
      viewModelBuilder: () => ThemeSettingViewModel(),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return ScreenTypeLayout(
          mobile: _ThemeSettingMobile(model),
          desktop: _ThemeSettingDesktop(model),
          tablet: _ThemeSettingTablet(model),
        );
      },
    );
  }
}
