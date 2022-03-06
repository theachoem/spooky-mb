library restore_view;

import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/models/backup_display_model.dart';
import 'package:spooky/core/models/backup_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/home/local_widgets/story_list.dart';
import 'package:spooky/views/restore/local_widgets/google_account_tile.dart';
import 'package:spooky/widgets/sp_button.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'package:spooky/widgets/sp_sections_tiles.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'restore_view_model.dart';

part 'restore_mobile.dart';
part 'restore_tablet.dart';
part 'restore_desktop.dart';

class RestoreView extends StatelessWidget {
  const RestoreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<RestoreViewModel>(
      create: (context) => RestoreViewModel(),
      builder: (context, viewModel, child) {
        return SpScreenTypeLayout(
          mobile: _RestoreMobile(viewModel),
          desktop: _RestoreDesktop(viewModel),
          tablet: _RestoreTablet(viewModel),
        );
      },
    );
  }
}
