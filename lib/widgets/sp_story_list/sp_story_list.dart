library sp_story_list;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/providers/story_list_configuration_provider.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/home/local_widgets/story_emtpy_widget.dart';
import 'package:spooky/core/types/sort_type.dart';
import 'package:spooky/widgets/sp_story_tile/sp_story_tile.dart';

part 'sp_layout_type.dart';
part 'sp_story_list_util.dart';

part 'layouts/base_list_layout.dart';
part 'layouts/list_layout_options.dart';
part 'layouts/library_list_layout.dart';
part 'layouts/diary_list_layout.dart';
part 'layouts/timeline_list_layout.dart';

class SpStoryList extends StatelessWidget {
  const SpStoryList({
    Key? key,
    required this.layoutType,
    required this.stories,
    required this.onRefresh,
  }) : super(key: key);

  final SpListLayoutType layoutType;
  final List<StoryDbModel>? stories;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    StoryListConfigurationProvider provider = Provider.of<StoryListConfigurationProvider>(context);

    if (kDebugMode) {
      print("BUILD: SpStoryList");
    }

    return FutureBuilder<List<StoryDbModel>>(
      future: stories == null || !provider.loaded
          ? null
          : compute(_fetchConfiguredStory, _ConfiguredStoryArgs(stories, provider)),
      builder: (context, snapshot) {
        List<StoryDbModel> configuredStories = snapshot.data ?? [];
        bool loading = stories == null || snapshot.data == null;
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: Stack(
            children: [
              if (!loading) buildList(configuredStories),
              buildLoading(loading),
              StoryEmptyWidget(
                isEmpty: !loading && configuredStories.isEmpty,
                pathType: null,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildList(List<StoryDbModel> stories) {
    final options = _ListLayoutOptions(stories);
    switch (layoutType) {
      case SpListLayoutType.library:
        return _LibraryListLayout(options: options);
      case SpListLayoutType.diary:
        return _DiaryListLayout(options: options);
      case SpListLayoutType.timeline:
        return _TimelineListLayout(options: options);
    }
  }

  Widget buildLoading(bool loading) {
    return IgnorePointer(
      child: Visibility(
        visible: loading,
        child: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
