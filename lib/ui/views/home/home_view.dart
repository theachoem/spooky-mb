library home_view;

import 'package:spooky/core/types/file_path_type.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/types/list_layout_type.dart';
import 'package:spooky/ui/views/home/local_widgets/home_app_bar.dart';
import 'package:spooky/ui/views/home/local_widgets/story_query_list.dart';
import 'package:spooky/ui/widgets/sp_list_layout_builder.dart';
import 'package:spooky/ui/widgets/sp_screen_type_layout.dart';
import 'package:spooky/ui/widgets/sp_tab_view.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:stacked/stacked.dart';
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
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(onTabChange, onYearChange, onListReloaderReady, onScrollControllerReady),
      onModelReady: (model) {},
      disposeViewModel: false,
      builder: (context, model, child) {
        return SpScreenTypeLayout(
          mobile: _HomeMobile(model),
          desktop: _HomeDesktop(model),
          tablet: _HomeTablet(model),
        );
      },
    );
  }
}
