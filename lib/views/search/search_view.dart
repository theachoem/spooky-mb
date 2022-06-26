library search_view;

import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/types/list_layout_type.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/views/home/local_widgets/story_query_list.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'search_view_model.dart';

part 'search_mobile.dart';

class SearchView extends StatelessWidget {
  const SearchView({
    Key? key,
    required this.initialQuery,
  }) : super(key: key);

  final StoryQueryOptionsModel? initialQuery;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SearchViewModel>(
      create: (context) => SearchViewModel(initialQuery),
      onModelReady: (context, viewModel) {},
      builder: (context, viewModel, child) {
        return _SearchMobile(viewModel);
      },
    );
  }
}
