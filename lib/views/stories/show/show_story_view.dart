import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/routes/base_route.dart';
import 'package:spooky/widgets/sp_feeling_picker/sp_feeling_button.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';

import 'show_story_view_model.dart';

part 'show_story_adaptive.dart';

class ShowStoryRoute extends BaseRoute {
  final int id;
  final StoryDbModel? story;

  ShowStoryRoute({
    required this.id,
    required this.story,
  });

  @override
  Widget buildPage(BuildContext context) => ShowStoryView(params: this);
}

class ShowStoryView extends StatelessWidget {
  const ShowStoryView({
    super.key,
    required this.params,
  });

  final ShowStoryRoute params;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ShowStoryViewModel>(
      create: (context) => ShowStoryViewModel(params: params, context: context),
      builder: (context, viewModel, child) {
        return _StoryDetailsAdaptive(viewModel);
      },
    );
  }
}
