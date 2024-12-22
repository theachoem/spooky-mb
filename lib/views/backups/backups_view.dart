import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/routes/base_route.dart';

import 'backups_view_model.dart';

part 'backups_adaptive.dart';

class BackupsRoute extends BaseRoute {
  BackupsRoute();

  @override
  Widget buildPage(BuildContext context) => BackupsView(params: this);

  @override
  bool get nestedRoute => true;
}

class BackupsView extends StatelessWidget {
  const BackupsView({
    super.key,
    required this.params,
  });

  final BackupsRoute params;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BackupsViewModel>(
      create: (context) => BackupsViewModel(params: params),
      builder: (context, viewModel, child) {
        return _BackupsAdaptive(viewModel);
      },
    );
  }
}
