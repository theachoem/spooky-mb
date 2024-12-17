import 'package:spooky_mb/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';

import 'archives_view_model.dart';

part 'archives_adaptive.dart';

class ArchivesView extends StatelessWidget {
  const ArchivesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ArchivesViewModel>(
      create: (context) => ArchivesViewModel(),
      builder: (context, viewModel, child) {
        return _ArchivesAdaptive(viewModel);
      },
    );
  }
}
