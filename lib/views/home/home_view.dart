library home_view;

import 'package:provider/provider.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/db/models/tag_db_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/main.dart';
import 'package:spooky/views/home/local_widgets/home_app_bar.dart';
import 'package:spooky/views/home/local_widgets/story_query_list.dart';
import 'package:spooky/widgets/sp_story_list/sp_story_list.dart';
import 'package:spooky/widgets/sp_tab_view.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:flutter/material.dart';
import 'home_view_model.dart';

part 'home_mobile.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    Key? key,
    required this.onMonthChange,
    required this.onYearChange,
    required this.onScrollControllerReady,
    required this.onTagChange,
  }) : super(key: key);

  final void Function(int index) onMonthChange;
  final void Function(int year) onYearChange;
  final void Function(String? tag) onTagChange;
  final void Function(ScrollController controller) onScrollControllerReady;

  // On CRUD
  static final GlobalKey homeKey = GlobalKey();
  static void reloadDocsCount() {
    homeKey.currentContext?.read<HomeViewModel>().reloadDocsCount();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>(
      create: (BuildContext context) => HomeViewModel(
        onMonthChange,
        onYearChange,
        onScrollControllerReady,
        onTagChange,
      ),
      builder: (context, viewModel, child) {
        return _HomeMobile(
          viewModel,
          key: homeKey,
        );
      },
    );
  }
}
