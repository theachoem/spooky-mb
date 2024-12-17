import 'package:spooky_mb/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky_mb/core/databases/models/story_db_model.dart';
import 'package:spooky_mb/views/home/local_widgets/home_end_drawer.dart';
import 'package:spooky_mb/views/home/local_widgets/home_flexible_space_bar.dart';
import 'package:spooky_mb/views/home/local_widgets/rounded_indicator.dart';
import 'package:spooky_mb/views/home/local_widgets/story_tile.dart';

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
