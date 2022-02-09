library init_pick_color_view;

import 'package:hexagon/hexagon.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/route/sp_route_config.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/ui/widgets/sp_button.dart';
import 'package:spooky/ui/widgets/sp_cross_fade.dart';
import 'package:spooky/ui/widgets/sp_pop_button.dart';
import 'package:spooky/ui/widgets/sp_tap_effect.dart';
import 'package:spooky/ui/widgets/sp_theme_switcher.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/constants/util_colors_constant.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'init_pick_color_view_model.dart';

part 'init_pick_color_mobile.dart';
part 'init_pick_color_tablet.dart';
part 'init_pick_color_desktop.dart';

@Deprecated('Use color button directly')
class InitPickColorView extends StatelessWidget {
  const InitPickColorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InitPickColorViewModel>.reactive(
      viewModelBuilder: () => InitPickColorViewModel(),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return ScreenTypeLayout(
          mobile: _InitPickColorMobile(model),
          desktop: _InitPickColorDesktop(model),
          tablet: _InitPickColorTablet(model),
        );
      },
    );
  }
}
