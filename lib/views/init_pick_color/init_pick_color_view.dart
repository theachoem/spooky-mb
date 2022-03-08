library init_pick_color_view;

import 'dart:math';
import 'package:provider/provider.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/providers/theme_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/views/init_pick_color/local_widgets/enhanced_bubble_lens.dart';
import 'package:spooky/widgets/sp_button.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'package:spooky/widgets/sp_theme_switcher.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/constants/util_colors_constant.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'init_pick_color_view_model.dart';

part 'init_pick_color_mobile.dart';
part 'init_pick_color_tablet.dart';
part 'init_pick_color_desktop.dart';

class InitPickColorView extends StatelessWidget {
  const InitPickColorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<InitPickColorViewModel>(
      create: (BuildContext context) => InitPickColorViewModel(),
      builder: (context, viewModel, child) {
        return SpScreenTypeLayout(
          mobile: _InitPickColorMobile(viewModel),
          desktop: _InitPickColorDesktop(viewModel),
          tablet: _InitPickColorTablet(viewModel),
        );
      },
    );
  }
}
