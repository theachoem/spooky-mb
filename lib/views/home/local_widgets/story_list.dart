import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/types/list_layout_type.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/core/types/sort_type.dart';
import 'package:spooky/providers/story_list_configuration_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/views/home/local_widgets/story_emtpy_widget.dart';
import 'package:spooky/views/home/local_widgets/story_tile.dart';
import 'package:spooky/widgets/sp_dimissable_background.dart';
import 'package:spooky/widgets/sp_list_layout_builder.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';

class _ConfiguredStoryArgs {
  final List<StoryDbModel>? stories;
  final bool shouldShowChip;
  final bool prioritied;
  final SortType? sortType;

  _ConfiguredStoryArgs(this.stories, StoryListConfigurationProvider configuration)
      : shouldShowChip = configuration.shouldShowChip,
        prioritied = configuration.prioritied,
        sortType = configuration.sortType;
}

DateTime _dateForCompare(StoryDbModel story) {
  return story.toDateTime();
}

List<StoryDbModel> _fetchConfiguredStory(_ConfiguredStoryArgs args) {
  List<StoryDbModel>? stories = args.stories;

  if (stories != null) {
    switch (args.sortType) {
      case SortType.oldToNew:
      case null:
        stories.sort((a, b) => (_dateForCompare(a)).compareTo(_dateForCompare(b)));
        break;
      case SortType.newToOld:
        stories.sort((a, b) => (_dateForCompare(a)).compareTo(_dateForCompare(b)));
        stories = stories.reversed.toList();
        break;
    }
    if (args.prioritied == true) stories.sort(((a, b) => b.starred == true ? 1 : -1));
  }

  if (kDebugMode) {
    print('_fetchConfiguredStory');
  }

  return stories ?? [];
}

class StoryList extends StatelessWidget {
  const StoryList({
    Key? key,
    required this.onRefresh,
    this.emptyMessage = "Empty",
    this.onDelete,
    this.onArchive,
    this.onUnarchive,
    this.onPutBack,
    this.controller,
    this.viewOnly = false,
    this.overridedLayout,
    this.pathType = PathType.docs,
    this.itemPadding = const EdgeInsets.all(ConfigConstant.margin2),
    required List<StoryDbModel>? stories,
  })  : _stories = stories,
        super(key: key);

  final PathType pathType;
  final Future<void> Function() onRefresh;
  final Future<bool> Function(StoryDbModel story)? onDelete;
  final Future<bool> Function(StoryDbModel story)? onArchive;
  final Future<bool> Function(StoryDbModel story)? onUnarchive;
  final Future<bool> Function(StoryDbModel story)? onPutBack;

  final ListLayoutType? overridedLayout;
  final String emptyMessage;
  final bool viewOnly;
  final EdgeInsets itemPadding;
  final ScrollController? controller;
  final List<StoryDbModel>? _stories;

  StoryDbModel? storyAt(List<StoryDbModel> stories, int index) {
    if (stories.isNotEmpty) {
      if (index >= 0 && stories.length > index) {
        return stories[index];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    StoryListConfigurationProvider provider = Provider.of<StoryListConfigurationProvider>(context);

    if (onDelete != null || onArchive != null || onUnarchive != null) {
      assert(onDelete != null);
      assert(onArchive != null);
      assert(onUnarchive != null);
    }

    if (kDebugMode) {
      print("BUILD: StoryList");
    }

    return FutureBuilder<List<StoryDbModel>>(
      future: _stories == null || !provider.loaded
          ? null
          : compute(_fetchConfiguredStory, _ConfiguredStoryArgs(_stories, provider)),
      builder: (context, snapshot) {
        List<StoryDbModel> configuredStories = snapshot.data ?? [];
        bool loading = _stories == null || snapshot.data == null;
        return RefreshIndicator(
          onRefresh: () => onRefresh(),
          child: Stack(
            children: [
              buildTimelineDivider(configuredStories),
              if (!loading) buildList(configuredStories),
              buildLoading(loading),
              StoryEmptyWidget(
                isEmpty: !loading && configuredStories.isEmpty,
                pathType: pathType,
              ),
            ],
          ),
        );
      },
    );
  }

  ListView buildList(List<StoryDbModel> configuredStories) {
    return ListView.builder(
      controller: controller,
      itemCount: configuredStories.length,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: kToolbarHeight),
      itemBuilder: (context, index) {
        StoryDbModel story = storyAt(configuredStories, index)!;
        StoryDbModel? previousStory = storyAt(configuredStories, index - 1);
        return IgnorePointer(
          ignoring: viewOnly,
          child: buildAnimatedTileWrapper(
            story: story,
            child: buildSeparatorTile(
              index: index,
              context: context,
              story: story,
              previousStory: previousStory,
              child: buildConfiguredTile(
                index: index,
                context: context,
                story: story,
                previousStory: previousStory,
              ),
            ),
          ),
        );
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

  Widget buildTimelineDivider(List<StoryDbModel>? stories) {
    return Positioned(
      left: 16.0 + 20,
      top: 0,
      bottom: 0,
      child: AnimatedOpacity(
        opacity: stories?.isNotEmpty == true ? 1 : 0,
        duration: ConfigConstant.fadeDuration,
        child: SpListLayoutBuilder(
          overridedLayout: overridedLayout,
          builder: (context, layoutType, loaded) {
            switch (layoutType) {
              case ListLayoutType.single:
                return const VerticalDivider(width: 1);
              case ListLayoutType.tabs:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget buildSeparatorTile({
    required BuildContext context,
    required Widget child,
    required int index,
    required StoryDbModel story,
    required StoryDbModel? previousStory,
  }) {
    String storyForCompare = "${story.year} ${story.month}";
    String previousStoryForCompare = "${previousStory?.year} ${previousStory?.month}";

    return SpListLayoutBuilder(
      overridedLayout: overridedLayout,
      builder: (context, layoutType, loaded) {
        Widget separator;

        switch (layoutType) {
          case ListLayoutType.single:
            if (storyForCompare != previousStoryForCompare) {
              separator = buildSingleLayoutSeparator(context, story, index);
            } else {
              separator = buildTabLayoutSeparator(index);
            }
            break;
          case ListLayoutType.tabs:
            separator = buildTabLayoutSeparator(index);
            break;
        }

        return Column(
          children: [
            separator,
            child,
          ],
        );
      },
    );
  }

  Widget buildTabLayoutSeparator(int index) {
    return SpListLayoutBuilder(
      overridedLayout: overridedLayout,
      builder: (context, layoutType, loaded) {
        switch (layoutType) {
          case ListLayoutType.single:
            return const SizedBox.shrink();
          case ListLayoutType.tabs:
            if (index == 0) return const SizedBox.shrink();
            return const Divider(height: 0);
        }
      },
    );
  }

  Widget buildSingleLayoutSeparator(
    BuildContext context,
    StoryDbModel story,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: ConfigConstant.margin2),
      child: Container(
        color: M3Color.of(context).background,
        child: Row(
          children: [
            const SizedBox(width: 16.0 + 1),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                color: M3Color.of(context).readOnly.surface2,
                borderRadius: ConfigConstant.circlarRadius2,
              ),
              child: Text(
                DateFormatHelper.toNameOfMonth().format(story.toDateTime()),
                style: M3TextTheme.of(context).labelSmall,
              ),
            ),
            if (index != 0)
              const Expanded(
                child: Divider(height: 0),
              )
          ],
        ),
      ),
    );
  }

  String buildIdentity(
    StoryDbModel? story,
  ) {
    if (story == null) return "";
    return [
      story.year,
      story.month,
      story.day,
      story.id,
    ].join("-");
  }

  Widget buildAnimatedTileWrapper({
    required Widget child,
    required StoryDbModel story,
  }) {
    return TweenAnimationBuilder<int>(
      key: ValueKey(buildIdentity(story)),
      duration: ConfigConstant.duration,
      tween: IntTween(begin: 0, end: 1),
      child: child,
      builder: (BuildContext context, int value, Widget? child) {
        return AnimatedContainer(
          duration: ConfigConstant.duration,
          child: AnimatedOpacity(
            duration: ConfigConstant.duration,
            opacity: value == 1 ? 1.0 : 0.0,
            curve: Curves.ease,
            child: child,
          ),
        );
      },
    );
  }

  Widget buildConfiguredTile({
    required BuildContext context,
    required int index,
    required StoryDbModel story,
    required StoryDbModel? previousStory,
  }) {
    // ignore: dead_code
    if (false && onDelete != null && onArchive != null && onUnarchive != null) {
      return Dismissible(
        key: ValueKey(buildIdentity(story)),
        background: buildDismissibleBackground(
          context: context,
          iconData: Icons.delete,
          alignment: Alignment.centerLeft,
          backgroundColor: M3Color.of(context).error,
          foregroundColor: M3Color.of(context).onError,
          label: "Delete",
        ),
        secondaryBackground: buildDismissibleBackground(
          context: context,
          iconData: story.unarchivable ? Icons.unarchive : Icons.archive,
          alignment: Alignment.centerRight,
          backgroundColor: M3Color.of(context).primary,
          foregroundColor: M3Color.of(context).onPrimary,
          label: story.unarchivable ? "Unarchive" : "Archive",
        ),
        confirmDismiss: (direction) async {
          switch (direction) {
            case DismissDirection.startToEnd:
              return onDelete!(story);
            case DismissDirection.vertical:
              return false;
            case DismissDirection.horizontal:
              return false;
            case DismissDirection.endToStart:
              if (story.unarchivable) {
                return onUnarchive!(story);
              } else if (story.archivable) {
                return onArchive!(story);
              }
            case DismissDirection.up:
              return false;
            case DismissDirection.down:
              return false;
            case DismissDirection.none:
              return false;
          }
        },
        child: buildStoryTile(
          context: context,
          story: story,
          previousStory: previousStory,
        ),
      );
    }

    return buildStoryTile(
      context: context,
      story: story,
      previousStory: previousStory,
    );
  }

  StoryTile buildStoryTile({
    required BuildContext context,
    required StoryDbModel story,
    required StoryDbModel? previousStory,
  }) {
    return StoryTile(
      key: ValueKey(story.updatedAt.millisecondsSinceEpoch),
      story: story,
      context: context,
      previousStory: previousStory,
      itemPadding: itemPadding,
      onRefresh: () => onRefresh(),
      onArchive: onArchive,
      onDelete: onDelete,
      onUnarchive: onUnarchive,
      onPutBack: onPutBack,
    );
  }

  Widget buildDismissibleBackground({
    required BuildContext context,
    required IconData iconData,
    required String label,
    Color? backgroundColor,
    Color? foregroundColor,
    Alignment alignment = Alignment.centerRight,
  }) {
    return SpDimissableBackground(
      alignment: alignment,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      iconData: iconData,
      label: label,
    );
  }
}
