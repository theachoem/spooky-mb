library init_pick_color_view;

import 'dart:math';
import 'package:bubble_lens/bubble_lens.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/providers/theme_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_expanded_app_bar.dart';
import 'package:spooky/widgets/sp_single_button_bottom_navigation.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/constants/util_colors_constant.dart';
import 'package:flutter/material.dart';
import 'package:spooky/widgets/sp_theme_switcher.dart';
import 'init_pick_color_view_model.dart';

part 'init_pick_color_adaptive.dart';

class InitPickColorView extends StatelessWidget {
  const InitPickColorView({
    Key? key,
    required this.showNextButton,
  }) : super(key: key);

  final bool showNextButton;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<InitPickColorViewModel>(
      create: (BuildContext context) => InitPickColorViewModel(showNextButton),
      builder: (context, viewModel, child) {
        return _InitPickColorAdaptive(viewModel);
      },
    );
  }
}
