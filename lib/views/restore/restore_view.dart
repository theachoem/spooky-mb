library restore_view;

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/backup/backup_service.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/models/backup_display_model.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_button.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
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
