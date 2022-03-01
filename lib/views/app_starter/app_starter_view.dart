library app_starter_view;

import 'package:provider/provider.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/providers/color_seed_provider.dart';
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
import 'package:flutter/material.dart';
import 'package:spooky/views/app_starter/app_starter_view_model.dart';

part 'app_starter_mobile.dart';
part 'app_starter_tablet.dart';
part 'app_starter_desktop.dart';

class AppStarterView extends StatelessWidget {
  const AppStarterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AppStarterViewModel>(
      create: (BuildContext context) => AppStarterViewModel(),
      builder: (context, viewModel, child) {
        return SpScreenTypeLayout(
          mobile: _AppStarterMobile(viewModel),
          desktop: _AppStarterDesktop(viewModel),
          tablet: _AppStarterTablet(viewModel),
        );
      },
    );
  }
}
