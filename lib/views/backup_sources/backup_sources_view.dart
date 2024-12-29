import 'package:provider/provider.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/services/backup_sources/base_backup_source.dart';
import 'package:spooky/providers/backup_sources_provider.dart';
import 'package:spooky/routes/base_route.dart';
import 'package:spooky/views/backup_sources/show/show_backup_source_view.dart';

import 'backup_sources_view_model.dart';

part 'backup_sources_adaptive.dart';

class BackupSourcesRoute extends BaseRoute {
  BackupSourcesRoute();

  @override
  Widget buildPage(BuildContext context) => BackupSourcesView(params: this);

  @override
  bool get nestedRoute => true;
}

class BackupSourcesView extends StatelessWidget {
  const BackupSourcesView({
    super.key,
    required this.params,
  });

  final BackupSourcesRoute params;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BackupSourcesViewModel>(
      create: (context) => BackupSourcesViewModel(params: params),
      builder: (context, viewModel, child) {
        return _BackupSourcesAdaptive(viewModel);
      },
    );
  }
}
