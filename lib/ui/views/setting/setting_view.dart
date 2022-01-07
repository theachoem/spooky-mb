library setting_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/core/route/router.gr.dart' as r;
import 'package:auto_route/auto_route.dart';
import 'package:spooky/utils/helpers/file_helper.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'setting_view_model.dart';

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
        return ScreenTypeLayout(
          mobile: _SettingMobile(model),
          desktop: _SettingDesktop(model),
          tablet: _SettingTablet(model),
        );
      },
    );
  }
}
