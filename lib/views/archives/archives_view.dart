import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'package:spooky/widgets/story_list/story_list.dart';

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
