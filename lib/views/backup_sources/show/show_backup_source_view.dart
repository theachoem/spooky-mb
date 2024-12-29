import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/objects/cloud_file_object.dart';
import 'package:spooky/core/services/backup_sources/base_backup_source.dart';
import 'package:spooky/core/services/date_format_service.dart';
import 'package:spooky/routes/base_route.dart';

import 'show_backup_source_view_model.dart';

part 'show_backup_source_adaptive.dart';

class ShowBackupSourceRoute extends BaseRoute {
  final BaseBackupSource source;

  ShowBackupSourceRoute({
    required this.source,
  });

  @override
  Widget buildPage(BuildContext context) => ShowBackupSourceView(params: this);

  @override
  bool get nestedRoute => true;
}

class ShowBackupSourceView extends StatelessWidget {
  const ShowBackupSourceView({
    super.key,
    required this.params,
  });

  final ShowBackupSourceRoute params;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ShowBackupSourceViewModel>(
      create: (context) => ShowBackupSourceViewModel(params: params),
      builder: (context, viewModel, child) {
        return _ShowBackupSourceAdaptive(viewModel);
      },
    );
  }
}
