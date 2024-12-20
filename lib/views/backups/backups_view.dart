import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';

import 'backups_view_model.dart';

part 'backups_adaptive.dart';

class BackupsView extends StatelessWidget {
  const BackupsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BackupsViewModel>(
      create: (context) => BackupsViewModel(),
      builder: (context, viewModel, child) {
        return _BackupsAdaptive(viewModel);
      },
    );
  }
}
