library main_view;

import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/routes/setting/base_route_setting.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/types/quick_actions_type.dart';
import 'package:spooky/providers/bottom_nav_items_provider.dart';
import 'package:spooky/providers/mini_sound_player_provider.dart';
import 'package:spooky/views/home/home_view.dart';
import 'package:spooky/views/main/local_widgets/home_bottom_navigation.dart';
import 'package:spooky/views/main/local_widgets/mini_player_scaffold.dart';
import 'package:spooky/views/main/main_view_item.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_show_hide_animator.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:flutter/material.dart';
import 'package:spooky/views/main/main_view_model.dart';

part 'main_view_adaptive.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<MainViewModel>(
      create: (BuildContext context) => MainViewModel(context),
      onModelReady: (context, viewModel) => onModelReady(context, viewModel),
      builder: (context, viewModel, child) {
        return WillPopScope(
          onWillPop: () async {
            if (viewModel.activeRouter != SpRouter.home) {
              viewModel.setActiveRouter(SpRouter.home);
              return false;
            } else {
              return true;
            }
          },
          child: _MainViewAdpative(viewModel),
        );
      },
    );
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
          viewModel.createStory(context, useTodayDate: true);
          break;
        case null:
          break;
      }
    });

    quickActions.setShortcutItems(
      QuickActionsType.values.map((e) {
        return ShortcutItem(
          localizedTitle: quickActionLabel(e),
          type: e.name,
          icon: quickActionIcon(e),
        );
      }).toList(),
    );
  }

  String quickActionLabel(QuickActionsType type) {
    switch (type) {
      case QuickActionsType.create:
        return tr("quick_action.new_story");
    }
  }

  String? quickActionIcon(QuickActionsType type) {
    switch (type) {
      case QuickActionsType.create:
        if (Platform.isAndroid) {
          return "ic_create_story";
        }
    }
    return null;
  }
}
