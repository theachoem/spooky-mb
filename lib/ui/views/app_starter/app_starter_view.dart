library app_starter_view;

import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/ui/widgets/sp_button.dart';
import 'package:spooky/ui/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'app_starter_view_model.dart';

part 'app_starter_mobile.dart';
part 'app_starter_tablet.dart';
part 'app_starter_desktop.dart';

class AppStarterView extends StatelessWidget {
  const AppStarterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppStarterViewModel>.reactive(
      viewModelBuilder: () => AppStarterViewModel(),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return ScreenTypeLayout(
          mobile: _AppStarterMobile(model),
          desktop: _AppStarterDesktop(model),
          tablet: _AppStarterTablet(model),
        );
      },
    );
  }
}
