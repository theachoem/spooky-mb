import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/databases/models/story_content_db_model.dart';
import 'package:spooky/core/services/date_format_service.dart';
import 'package:spooky/routes/base_route.dart';
import 'package:spooky/views/stories/changes/show/show_change_view.dart';
import 'package:spooky/widgets/sp_fade_in.dart';
import 'package:spooky/widgets/sp_markdown_body.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';

import 'story_changes_view_model.dart';

part 'story_changes_adaptive.dart';

class StoryChangesRoute extends BaseRoute {
  final int id;

  StoryChangesRoute({
    required this.id,
  });

  @override
  Widget buildPage(BuildContext context) => StoryChangesView(params: this);
}

class StoryChangesView extends StatelessWidget {
  const StoryChangesView({
    super.key,
    required this.params,
  });

  final StoryChangesRoute params;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<StoryChangesViewModel>(
      create: (context) => StoryChangesViewModel(params: params),
      builder: (context, viewModel, child) {
        return _StoryChangesAdaptive(viewModel);
      },
    );
  }
}
