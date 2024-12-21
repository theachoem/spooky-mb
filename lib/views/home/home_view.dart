import 'package:provider/provider.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/services/date_format_service.dart';
import 'package:spooky/providers/local_auth_provider.dart';
import 'package:spooky/views/home/local_widgets/home_years_view.dart';
import 'package:spooky/views/home/local_widgets/rounded_indicator.dart';
import 'package:spooky/views/archives/archives_view.dart';
import 'package:spooky/views/backups/backups_view.dart';
import 'package:spooky/views/search/search_view.dart';
import 'package:spooky/views/tags/tags_view.dart';
import 'package:spooky/views/theme/theme_view.dart';
import 'package:spooky/widgets/sp_nested_navigation.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'package:spooky/widgets/story_list/story_list_timeline_verticle_divider.dart';
import 'package:spooky/widgets/story_list/story_tile_list_item.dart';

import 'home_view_model.dart';

part 'home_adaptive.dart';
part 'local_widgets/home_end_drawer.dart';
part 'local_widgets/home_scaffold.dart';
part 'local_widgets/home_app_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>(
      create: (context) => HomeViewModel(),
      builder: (context, viewModel, child) {
        return _HomeAdaptive(viewModel);
      },
    );
  }
}
