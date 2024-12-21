import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';

import 'settings_view_model.dart';

part 'settings_adaptive.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SettingsViewModel>(
      create: (context) => SettingsViewModel(),
      builder: (context, viewModel, child) {
        return _SettingsAdaptive(viewModel);
      },
    );
  }
}
