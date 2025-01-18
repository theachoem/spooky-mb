import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:spooky/app_theme.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/objects/backup_file_object.dart';
import 'package:spooky/core/services/color_from_day_service.dart';
import 'package:spooky/core/services/date_format_service.dart';
import 'package:spooky/providers/backup_provider.dart';
import 'package:spooky/routes/base_route.dart';
import 'package:spooky/views/backup/local_widgets/user_profile_collapsible_tile.dart';
import 'package:spooky/widgets/sp_default_scroll_controller.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';

import 'backup_view_model.dart';

part 'backup_adaptive.dart';

class BackupRoute extends BaseRoute {
  BackupRoute();

  @override
  Widget buildPage(BuildContext context) => BackupView(params: this);

  @override
  bool get nestedRoute => true;
}

class BackupView extends StatelessWidget {
  const BackupView({
    super.key,
    required this.params,
  });

  final BackupRoute params;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BackupViewModel>(
      create: (context) => BackupViewModel(context: context, params: params),
      builder: (context, viewModel, child) {
        return _BackupAdaptive(viewModel);
      },
    );
  }
}
