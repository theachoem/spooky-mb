import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/databases/models/story_content_db_model.dart';
import 'package:spooky/routes/base_route.dart';

import 'show_change_view_model.dart';

part 'show_change_adaptive.dart';

class ShowChangeRoute extends BaseRoute {
  ShowChangeRoute({
    required this.content,
  });

  final StoryContentDbModel content;

  @override
  Widget buildPage(BuildContext context) => ShowChangeView(params: this);
}

class ShowChangeView extends StatelessWidget {
  const ShowChangeView({
    super.key,
    required this.params,
  });

  final ShowChangeRoute params;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ShowChangeViewModel>(
      create: (context) => ShowChangeViewModel(params: params),
      builder: (context, viewModel, child) {
        return _ShowChangeAdaptive(viewModel);
      },
    );
  }
}
