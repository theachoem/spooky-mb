import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/databases/models/story_content_db_model.dart';
import 'package:spooky/core/services/date_format_service.dart';
import 'package:spooky/routes/utils/animated_page_route.dart';
import 'package:spooky/views/stories/changes/show/show_change_view.dart';
import 'package:spooky/widgets/sp_fade_in.dart';
import 'package:spooky/widgets/sp_markdown_body.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';

import 'changes_story_view_model.dart';

part 'changes_story_adaptive.dart';

class ChangesStoryView extends StatelessWidget {
  const ChangesStoryView({
    super.key,
    required this.id,
  });

  final int id;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ChangesStoryViewModel>(
      create: (context) => ChangesStoryViewModel(params: this),
      builder: (context, viewModel, child) {
        return _ChangesStoryAdaptive(viewModel);
      },
    );
  }
}
