library theme_setting_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/core/storages/local_storages/sort_type_storage.dart';
import 'package:spooky/core/types/list_layout_type.dart';
import 'package:spooky/core/types/sort_type.dart';
import 'package:spooky/providers/theme_mode_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/providers/show_chips_provider.dart';
import 'package:spooky/widgets/sp_color_picker.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_list_layout_builder.dart';
import 'package:spooky/widgets/sp_overlay_popup_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'package:spooky/widgets/sp_sections_tiles.dart';
import 'package:spooky/widgets/sp_theme_switcher.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/extensions/string_extension.dart';

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
    return ViewModelProvider<ThemeSettingViewModel>(
      create: (BuildContext context) => ThemeSettingViewModel(),
      builder: (context, viewModel, child) {
        return SpScreenTypeLayout(
          mobile: _ThemeSettingMobile(viewModel),
          desktop: _ThemeSettingDesktop(viewModel),
          tablet: _ThemeSettingTablet(viewModel),
        );
      },
    );
  }
}
