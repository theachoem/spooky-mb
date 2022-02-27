library main_view;

import 'dart:io';

import 'package:quick_actions/quick_actions.dart';
import 'package:spooky/utils/util_widgets/app_local_auth.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/core/types/quick_actions_type.dart';
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
import 'package:stacked/stacked.dart';
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
      child: ViewModelBuilder<MainViewModel>.reactive(
        viewModelBuilder: () => MainViewModel(),
        onModelReady: (model) => onModelReady(model, context),
        disposeViewModel: false,
        builder: (context, model, child) {
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

  void onModelReady(MainViewModel model, BuildContext context) {
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
          model.createStory(context);
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
