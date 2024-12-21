import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';

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
