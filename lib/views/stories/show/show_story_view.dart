import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/widgets/sp_feeling_picker/sp_feeling_button.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';

import 'show_story_view_model.dart';

part 'show_story_adaptive.dart';

class ShowStoryView extends StatelessWidget {
  const ShowStoryView({
    super.key,
    required this.id,
  });

  final int id;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ShowStoryViewModel>(
      create: (context) => ShowStoryViewModel(params: this, context: context),
      builder: (context, viewModel, child) {
        return _StoryDetailsAdaptive(viewModel);
      },
    );
  }
}
