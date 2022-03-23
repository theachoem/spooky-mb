library bottom_nav_setting_view;

import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/models/bottom_nav_item_list_model.dart';
import 'package:spooky/core/models/bottom_nav_item_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/providers/bottom_nav_items_provider.dart';
import 'package:spooky/views/main/main_view_item.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'bottom_nav_setting_view_model.dart';

part 'bottom_nav_setting_mobile.dart';
part 'bottom_nav_setting_tablet.dart';
part 'bottom_nav_setting_desktop.dart';

class BottomNavSettingView extends StatelessWidget {
  const BottomNavSettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BottomNavSettingViewModel>(
      create: (context) => BottomNavSettingViewModel(),
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _BottomNavSettingMobile(viewModel),
          desktop: _BottomNavSettingDesktop(viewModel),
          tablet: _BottomNavSettingTablet(viewModel),
        );
      },
    );
  }
}
