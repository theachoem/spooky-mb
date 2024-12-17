import 'package:spooky_mb/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';

import 'tags_view_model.dart';

part 'tags_adaptive.dart';

class TagsView extends StatelessWidget {
  const TagsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<TagsViewModel>(
      create: (context) => TagsViewModel(),
      builder: (context, viewModel, child) {
        return _TagsAdaptive(viewModel);
      },
    );
  }
}
