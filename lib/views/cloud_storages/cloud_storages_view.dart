library clouds_storage_view;

import 'dart:math';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/backups/providers/base_cloud_provider.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/cloud_storages/local_widgets/backup_destination_tile.dart';
import 'package:spooky/views/cloud_storages/local_widgets/backups_destination_tile.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_button.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_sections_tiles.dart';
import 'package:spooky/widgets/sp_theme_switcher.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'cloud_storages_view_model.dart';

part 'cloud_storages_mobile.dart';
part 'cloud_storages_tablet.dart';
part 'cloud_storages_desktop.dart';

class CloudStoragesView extends StatelessWidget {
  const CloudStoragesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<CloudStoragesViewModel>(
      create: (context) => CloudStoragesViewModel(),
      onModelReady: (context, viewModel) {},
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _CloudStoragesMobile(viewModel),
          desktop: _CloudStoragesDesktop(viewModel),
          tablet: _CloudStoragesTablet(viewModel),
        );
      },
    );
  }
}
