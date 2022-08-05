library backups_details_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/backups/destinations/cloud_file_tuple.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/bottom_sheet_service.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/extensions/string_extension.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_button.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/widgets/sp_single_button_bottom_navigation.dart';
import 'package:spooky/widgets/sp_story_list/sp_story_list.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'backups_details_view_model.dart';

part 'backups_details_mobile.dart';

class BackupsDetailsView extends StatelessWidget {
  const BackupsDetailsView({
    Key? key,
    required this.destination,
    required this.cloudFiles,
    required this.initialCloudFile,
  }) : super(key: key);

  final BaseBackupDestination destination;
  final List<CloudFileTuple> cloudFiles;
  final CloudFileModel initialCloudFile;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BackupsDetailsViewModel>(
      create: (context) => BackupsDetailsViewModel(destination, cloudFiles, initialCloudFile),
      onModelReady: (context, viewModel) {},
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _BackupsDetailsMobile(viewModel),
          // desktop: _BackupsDetailsDesktop(viewModel),
          // tablet: _BackupsDetailsTablet(viewModel),
        );
      },
    );
  }
}
