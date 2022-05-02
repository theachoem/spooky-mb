library home_view;

import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/types/list_layout_type.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/views/home/local_widgets/home_app_bar.dart';
import 'package:spooky/views/home/local_widgets/story_query_list.dart';
import 'package:spooky/widgets/sp_list_layout_builder.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'package:spooky/widgets/sp_tab_view.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:flutter/material.dart';
import 'home_view_model.dart';

part 'home_mobile.dart';
part 'home_tablet.dart';
part 'home_desktop.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    Key? key,
    required this.onTabChange,
    required this.onYearChange,
    required this.onListReloaderReady,
    required this.onScrollControllerReady,
  }) : super(key: key);

  final void Function(int index) onTabChange;
  final void Function(int year) onYearChange;
  final void Function(void Function()) onListReloaderReady;
  final void Function(ScrollController controller) onScrollControllerReady;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>(
      create: (BuildContext context) => HomeViewModel(
        onTabChange,
        onYearChange,
        onListReloaderReady,
        onScrollControllerReady,
      ),
      builder: (context, viewModel, child) {
        return SpScreenTypeLayout(
          mobile: _HomeMobile(viewModel),
          desktop: _HomeDesktop(viewModel),
          tablet: _HomeTablet(viewModel),
        );
      },
    );
  }
}
