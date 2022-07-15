library sp_story_list;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/providers/has_tags_changes_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/views/home/local_widgets/story_emtpy_widget.dart';
import 'package:spooky/widgets/sp_list_layout_builder.dart';
import 'package:spooky/widgets/sp_story_list/has_tag_changes_alerter.dart';
import 'package:spooky/widgets/sp_story_tile/sp_story_tile.dart';

part 'utils/sp_list_layout_type.dart';
part 'utils/list_layout_options.dart';

part 'layouts/base_list_layout.dart';
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
    this.hasDifferentYear = true,
  }) : super(key: key);

  final bool viewOnly;
  final ScrollController? controller;
  final SpListLayoutType? overridedLayout;
  final List<StoryDbModel>? stories;
  final Future<void> Function() onRefresh;
  final bool hasDifferentYear;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print("BUILD: SpStoryList");
    bool loading = stories == null;
    return buildParents(
      loading,
      stories ?? [],
    );
  }

  Widget buildParents(bool loading, List<StoryDbModel> configuredStories) {
    return SpListLayoutBuilder(
      overridedLayout: overridedLayout,
      builder: (context, layoutType, loaded) {
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: Stack(
            children: [
              if (!loading && loaded) buildTimelineDivider(configuredStories, layoutType),
              if (!loading && loaded) buildListWrapper(configuredStories, layoutType),
              buildLoading(loading),
              StoryEmptyWidget(
                isEmpty: !loading && configuredStories.isEmpty,
                pathType: null,
              ),
              if (layoutType == SpListLayoutType.library)
                const Positioned(
                  top: 0,
                  left: 16,
                  right: 16,
                  child: HasTagChangesAlerter(),
                )
            ],
          ),
        );
      },
    );
  }

  Widget buildListWrapper(List<StoryDbModel> configuredStories, SpListLayoutType layoutType) {
    if (layoutType == SpListLayoutType.library) {
      return Consumer<HasTagsChangesProvider>(
        child: buildList(configuredStories, layoutType),
        builder: (context, provider, child) {
          return Padding(
            padding: EdgeInsets.only(top: provider.hasChanges ? 24.0 : 0),
            child: child,
          );
        },
      );
    } else {
      return buildList(configuredStories, layoutType);
    }
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
                return const SizedBox.shrink();
              case SpListLayoutType.diary:
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
      onRefresh: onRefresh,
      hasDifferentYear: hasDifferentYear,
    );
    return Builder(
      builder: (context) {
        switch (layoutType) {
          case SpListLayoutType.library:
            return _LibraryListLayout(options: options);
          case SpListLayoutType.diary:
            return _DiaryListLayout(options: options);
          case SpListLayoutType.timeline:
            return _TimelineListLayout(
              options: options,
            );
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
