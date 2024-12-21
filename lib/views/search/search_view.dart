import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/widgets/story_list/story_list.dart';

import 'search_view_model.dart';

part 'search_adaptive.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SearchViewModel>(
      create: (context) => SearchViewModel(),
      builder: (context, viewModel, child) {
        return _SearchAdaptive(viewModel);
      },
    );
  }
}
