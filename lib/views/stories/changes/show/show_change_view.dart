import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/databases/models/story_content_db_model.dart';

import 'show_change_view_model.dart';

part 'show_change_adaptive.dart';

class ShowChangeView extends StatelessWidget {
  const ShowChangeView({
    super.key,
    required this.content,
  });

  final StoryContentDbModel content;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ShowChangeViewModel>(
      create: (context) => ShowChangeViewModel(params: this),
      builder: (context, viewModel, child) {
        return _ShowChangeAdaptive(viewModel);
      },
    );
  }
}
