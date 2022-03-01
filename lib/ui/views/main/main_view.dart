library main_view;

import 'dart:io';
import 'package:provider/provider.dart';
import 'package:spooky/utils/util_widgets/app_local_auth.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/ui/views/explore/explore_view.dart';
import 'package:spooky/ui/views/home/home_view.dart';
import 'package:spooky/ui/views/main/main_view_item.dart';
import 'package:spooky/ui/views/setting/setting_view.dart';
import 'package:spooky/ui/widgets/sp_bottom_navaigation_bar.dart';
import 'package:spooky/ui/widgets/sp_screen_type_layout.dart';
import 'package:spooky/ui/widgets/sp_show_hide_animator.dart';
import 'package:spooky/ui/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/util_widgets/measure_size.dart';

import 'package:flutter/material.dart';
import 'package:spooky/ui/views/main/main_view_model.dart';

part 'main_mobile.dart';
part 'main_tablet.dart';
part 'main_desktop.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppLocalAuth(
      child: ListenableProvider(
        create: (BuildContext context) => MainViewModel(context),
        builder: (context, child) {
          MainViewModel model = Provider.of<MainViewModel>(context);
          return SpScreenTypeLayout(
            listener: (info) {
              if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
                model.setShouldShowBottomNav(!info.isSmall);
              }
            },
            mobile: _MainMobile(model),
            desktop: _MainDesktop(model),
            tablet: _MainTablet(model),
          );
        },
      ),
    );
  }
}
