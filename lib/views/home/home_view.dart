import 'package:spooky_mb/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';

import 'home_view_model.dart';

part 'home_adaptive.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>(
      create: (context) => HomeViewModel(),
      builder: (context, viewModel, child) {
        return _HomeAdaptive(viewModel);
      },
    );
  }
}
