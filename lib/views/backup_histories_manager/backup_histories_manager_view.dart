library backup_histories_manager_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/backups/models/backups_metadata.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/models/cloud_file_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_small_chip.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'backup_histories_manager_view_model.dart';

part 'backup_histories_manager_mobile.dart';

class BackupHistoriesManagerView extends StatelessWidget {
  const BackupHistoriesManagerView({
    Key? key,
    required this.destination,
  }) : super(key: key);

  final BaseBackupDestination destination;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BackupHistoriesManagerViewModel>(
      create: (context) => BackupHistoriesManagerViewModel(destination),
      onModelReady: (context, viewModel) {},
      builder: (context, viewModel, child) {
        return _BackupHistoriesManagerMobile(viewModel);
      },
    );
  }
}
