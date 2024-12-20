import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';

import 'theme_view_model.dart';

part 'theme_adaptive.dart';

class ThemeView extends StatelessWidget {
  const ThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ThemeViewModel>(
      create: (context) => ThemeViewModel(),
      builder: (context, viewModel, child) {
        return _ThemeAdaptive(viewModel);
      },
    );
  }
}
