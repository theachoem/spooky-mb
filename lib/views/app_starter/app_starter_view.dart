library app_starter_view;

import 'package:spooky/app.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/widgets/sp_button.dart';
import 'package:spooky/widgets/sp_color_picker.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_overlay_popup_button.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'package:spooky/widgets/sp_theme_switcher.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'app_starter_view_model.dart';

part 'app_starter_mobile.dart';
part 'app_starter_tablet.dart';
part 'app_starter_desktop.dart';

class AppStarterView extends StatelessWidget {
  const AppStarterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (BuildContext context) => AppStarterViewModel(),
      builder: (context, child) {
        AppStarterViewModel model = Provider.of<AppStarterViewModel>(context);
        return SpScreenTypeLayout(
          mobile: _AppStarterMobile(model),
          desktop: _AppStarterDesktop(model),
          tablet: _AppStarterTablet(model),
        );
      },
    );
  }
}
