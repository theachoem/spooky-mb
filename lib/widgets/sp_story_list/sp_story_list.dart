library sp_story_list;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/providers/story_list_configuration_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/views/home/local_widgets/story_emtpy_widget.dart';
import 'package:spooky/core/types/sort_type.dart';
import 'package:spooky/widgets/sp_list_layout_builder.dart';
import 'package:spooky/widgets/sp_story_tile/sp_story_tile.dart';

part 'utils/sp_layout_type.dart';
part 'utils/sp_story_list_util.dart';

part 'layouts/base_list_layout.dart';
part 'utils/list_layout_options.dart';
part 'layouts/library_list_layout.dart';
part 'layouts/diary_list_layout.dart';
part 'layouts/timeline_list_layout.dart';

class SpStoryList extends StatelessWidget {
  const SpStoryList({
    Key? key,
    required this.stories,
    required this.onRefresh,
    this.overridedLayout,
    this.controller,
    this.viewOnly = false,
  }) : super(key: key);

  final bool viewOnly;
  final ScrollController? controller;
  final SpListLayoutType? overridedLayout;
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
        return SpListLayoutBuilder(
          overridedLayout: overridedLayout,
          builder: (context, layoutType, loaded) {
            loading = loading && !loaded;
            return RefreshIndicator(
              onRefresh: onRefresh,
              child: Stack(
                children: [
                  if (!loading) buildTimelineDivider(configuredStories, layoutType),
                  if (!loading) buildList(configuredStories, layoutType),
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
      },
    );
  }

  Widget buildTimelineDivider(
    List<StoryDbModel>? stories,
    SpListLayoutType layoutType,
  ) {
    return Positioned(
      left: 16.0 + 20,
      top: 0,
      bottom: 0,
      child: AnimatedOpacity(
        opacity: stories?.isNotEmpty == true ? 1 : 0,
        duration: ConfigConstant.fadeDuration,
        child: Builder(
          builder: (context) {
            switch (layoutType) {
              case SpListLayoutType.library:
              case SpListLayoutType.diary:
                return const SizedBox.shrink();
              case SpListLayoutType.timeline:
                return const VerticalDivider(width: 1);
            }
          },
        ),
      ),
    );
  }

  Widget buildList(
    List<StoryDbModel> stories,
    SpListLayoutType layoutType,
  ) {
    final options = _ListLayoutOptions(
      stories: stories,
      controller: controller,
      viewOnly: viewOnly,
    );

    return Builder(
      builder: (context) {
        switch (layoutType) {
          case SpListLayoutType.library:
            return _LibraryListLayout(options: options);
          case SpListLayoutType.diary:
            return _DiaryListLayout(options: options);
          case SpListLayoutType.timeline:
            return _TimelineListLayout(options: options);
        }
      },
    );
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
