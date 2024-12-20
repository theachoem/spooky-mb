import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import 'story_details_view_model.dart';

part 'story_details_adaptive.dart';

class StoryDetailsView extends StatelessWidget {
  const StoryDetailsView({
    super.key,
    required this.id,
  });

  final int? id;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<StoryDetailsViewModel>(
      create: (context) => StoryDetailsViewModel(params: this, context: context),
      builder: (context, viewModel, child) {
        return _StoryDetailsAdaptive(viewModel);
      },
    );
  }
}
