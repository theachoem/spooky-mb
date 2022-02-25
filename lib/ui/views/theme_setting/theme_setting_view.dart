library theme_setting_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/storages/local_storages/sort_type_storage.dart';
import 'package:spooky/core/types/list_layout_type.dart';
import 'package:spooky/core/types/sort_type.dart';
import 'package:spooky/initial_theme.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/ui/widgets/sp_color_picker.dart';
import 'package:spooky/ui/widgets/sp_cross_fade.dart';
import 'package:spooky/ui/widgets/sp_list_layout_builder.dart';
import 'package:spooky/ui/widgets/sp_overlay_popup_button.dart';
import 'package:spooky/ui/widgets/sp_pop_button.dart';
import 'package:spooky/ui/widgets/sp_screen_type_layout.dart';
import 'package:spooky/ui/widgets/sp_sections_tiles.dart';
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
        return SpScreenTypeLayout(
          mobile: _ThemeSettingMobile(model),
          desktop: _ThemeSettingDesktop(model),
          tablet: _ThemeSettingTablet(model),
        );
      },
    );
  }
}
