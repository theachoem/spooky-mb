library archive_view;

import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/home/local_widgets/story_query_list.dart';
import 'package:spooky/utils/extensions/string_extension.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'archive_view_model.dart';

part 'archive_mobile.dart';
part 'archive_tablet.dart';
part 'archive_desktop.dart';

class ArchiveView extends StatelessWidget {
  const ArchiveView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ArchiveViewModel>(
      create: (BuildContext context) => ArchiveViewModel(),
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _ArchiveMobile(viewModel),
          desktop: _ArchiveDesktop(viewModel),
          tablet: _ArchiveTablet(viewModel),
        );
      },
    );
  }
}
