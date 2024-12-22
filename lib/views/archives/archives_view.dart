import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/routes/base_route.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'package:spooky/widgets/story_list/story_list.dart';

import 'archives_view_model.dart';

part 'archives_adaptive.dart';

class ArchivesRoute extends BaseRoute {
  ArchivesRoute();

  @override
  Widget buildPage(BuildContext context) => ArchivesView(params: this);

  @override
  bool get nestedRoute => true;
}

class ArchivesView extends StatelessWidget {
  const ArchivesView({
    super.key,
    required this.params,
  });

  final ArchivesRoute params;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ArchivesViewModel>(
      create: (context) => ArchivesViewModel(params: params),
      builder: (context, viewModel, child) {
        return _ArchivesAdaptive(viewModel);
      },
    );
  }
}
