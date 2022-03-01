library font_manager_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/providers/color_seed_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/theme_config.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/font_manager/local_widgets/font_manager_search_delegate.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:url_launcher/url_launcher.dart';
import 'font_manager_view_model.dart';

part 'font_manager_mobile.dart';
part 'font_manager_tablet.dart';
part 'font_manager_desktop.dart';

class FontManagerView extends StatelessWidget {
  const FontManagerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<FontManagerViewModel>(
      create: (_) => FontManagerViewModel(),
      builder: (context, viewModel, child) {
        return SpScreenTypeLayout(
          mobile: _FontManagerMobile(viewModel),
          desktop: _FontManagerDesktop(viewModel),
          tablet: _FontManagerTablet(viewModel),
        );
      },
    );
  }
}
