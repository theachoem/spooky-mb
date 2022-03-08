library archive_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/types/file_path_type.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/views/home/local_widgets/story_query_list.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:flutter/material.dart';
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
        return SpScreenTypeLayout(
          mobile: _ArchiveMobile(viewModel),
          desktop: _ArchiveDesktop(viewModel),
          tablet: _ArchiveTablet(viewModel),
        );
      },
    );
  }
}
