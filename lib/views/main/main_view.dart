library main_view;

import 'dart:io';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/routes/setting/base_route_setting.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/types/quick_actions_type.dart';
import 'package:spooky/providers/bottom_nav_items_provider.dart';
import 'package:spooky/providers/mini_sound_player_provider.dart';
import 'package:spooky/utils/util_widgets/app_local_auth.dart';
import 'package:spooky/views/cloud_storage/cloud_storage_view.dart';
import 'package:spooky/views/explore/explore_view.dart';
import 'package:spooky/views/home/home_view.dart';
import 'package:spooky/views/main/local_widgets/mini_player_scaffold.dart';
import 'package:spooky/views/main/main_view_item.dart';
import 'package:spooky/views/not_found/not_found_view.dart';
import 'package:spooky/views/setting/setting_view.dart';
import 'package:spooky/views/sound_list/sound_list_view.dart';
import 'package:spooky/views/theme_setting/theme_setting_view.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_bottom_navaigation_bar.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'package:spooky/widgets/sp_show_hide_animator.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/util_widgets/measure_size.dart';
import 'package:flutter/material.dart';
import 'package:spooky/views/main/main_view_model.dart';

part 'main_mobile.dart';
part 'main_tablet.dart';
part 'main_desktop.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppLocalAuth(
      child: ViewModelProvider<MainViewModel>(
        create: (BuildContext context) => MainViewModel(context),
        onModelReady: (context, viewModel) => onModelReady(context, viewModel),
        builder: (context, viewModel, child) {
          return SpScreenTypeLayout(
            listener: (info) => listener(viewModel, info),
            mobile: _MainMobile(viewModel),
            desktop: _MainDesktop(viewModel),
            tablet: _MainTablet(viewModel),
          );
        },
      ),
    );
  }

  void listener(MainViewModel viewModel, SizingInformation info) {
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      viewModel.setShouldShowBottomNav(!info.isSmall);
    }
  }

  void onModelReady(BuildContext context, MainViewModel viewModel) {
    if (!(Platform.isAndroid || Platform.isIOS)) return;
    QuickActions quickActions = const QuickActions();

    quickActions.initialize((shortcutType) {
      QuickActionsType? type;
      for (QuickActionsType item in QuickActionsType.values) {
        if (shortcutType == item.name) {
          type = item;
          break;
        }
      }
      switch (type) {
        case QuickActionsType.create:
          viewModel.createStory(context);
          break;
        case null:
          break;
      }
    });

    quickActions.setShortcutItems(
      QuickActionsType.values.map((e) {
        return ShortcutItem(localizedTitle: quickActionLabel(e), type: e.name);
      }).toList(),
    );
  }

  String quickActionLabel(QuickActionsType type) {
    switch (type) {
      case QuickActionsType.create:
        return "Create New Story";
    }
  }
}
