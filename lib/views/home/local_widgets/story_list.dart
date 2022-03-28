import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/types/list_layout_type.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/views/home/local_widgets/story_tile.dart';
import 'package:spooky/widgets/sp_dimissable_background.dart';
import 'package:spooky/widgets/sp_list_layout_builder.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';

class StoryList extends StatelessWidget {
  const StoryList({
    Key? key,
    required this.onRefresh,
    required this.stories,
    this.emptyMessage = "Empty",
    this.onDelete,
    this.onArchive,
    this.onUnarchive,
    this.controller,
    this.viewOnly = false,
    this.itemPadding = const EdgeInsets.all(ConfigConstant.margin2),
  }) : super(key: key);

  final Future<void> Function() onRefresh;
  final Future<bool> Function(StoryModel story)? onDelete;
  final Future<bool> Function(StoryModel story)? onArchive;
  final Future<bool> Function(StoryModel story)? onUnarchive;
  final List<StoryModel>? stories;
  final String emptyMessage;
  final bool viewOnly;
  final EdgeInsets itemPadding;
  final ScrollController? controller;

  StoryModel? storyAt(int index) {
    if (stories?.isNotEmpty == true) {
      if (index >= 0 && stories!.length > index) {
        return stories![index];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (onDelete != null || onArchive != null || onUnarchive != null) {
      assert(onDelete != null);
      assert(onArchive != null);
      assert(onUnarchive != null);
    }
    return RefreshIndicator(
      onRefresh: () => onRefresh(),
      child: Stack(
        children: [
          buildTimelineDivider(),
          ListView.builder(
            controller: controller,
            itemCount: stories?.length ?? 0,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: kToolbarHeight, top: ConfigConstant.margin0),
            itemBuilder: (context, index) {
              return IgnorePointer(
                ignoring: viewOnly,
                child: buildAnimatedTileWrapper(
                  index: index,
                  child: buildSeparatorTile(
                    index: index,
                    context: context,
                    child: buildConfiguredTile(index, context),
                  ),
                ),
              );
            },
          ),
          buildLoading(),
          buildEmpty(),
        ],
      ),
    );
  }

  Widget buildEmpty() {
    return IgnorePointer(
      child: Visibility(
        visible: stories?.isEmpty == true,
        child: Container(
          alignment: Alignment.center,
          child: Text(emptyMessage),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return IgnorePointer(
      child: Center(
        child: Visibility(
          visible: stories == null,
          child: const CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }

  Widget buildTimelineDivider() {
    return Positioned(
      left: 16.0 + 20,
      top: 0,
      bottom: 0,
      child: AnimatedOpacity(
        opacity: stories?.isNotEmpty == true ? 1 : 0,
        duration: ConfigConstant.fadeDuration,
        child: SpListLayoutBuilder(
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
    required int index,
    required BuildContext context,
    required Widget child,
  }) {
    StoryModel? story = storyAt(index);
    StoryModel? previousStory = storyAt(index - 1);

    String storyForCompare = "${story?.path.year} ${story?.path.month}";
    String previousStoryForCompare = "${previousStory?.path.year} ${previousStory?.path.month}";

    return SpListLayoutBuilder(
      builder: (context, layoutType, loaded) {
        Widget separator;

        switch (layoutType) {
          case ListLayoutType.single:
            if (storyForCompare != previousStoryForCompare) {
              separator = buildSingleLayoutSeparator(context, index);
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

  Widget buildSingleLayoutSeparator(BuildContext context, int index) {
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
                DateFormatHelper.toNameOfMonth().format(stories![index].path.toDateTime()),
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

  Widget buildAnimatedTileWrapper({
    required Widget child,
    required int index,
  }) {
    return TweenAnimationBuilder<int>(
      key: ValueKey(stories?[index].file?.path),
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

  Widget buildConfiguredTile(int index, BuildContext context) {
    final StoryModel content = stories![index];
    if (onDelete != null && onArchive != null && onUnarchive != null) {
      return Dismissible(
        key: ValueKey(content.file?.path),
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
          iconData: content.archived ? Icons.unarchive : Icons.archive,
          alignment: Alignment.centerRight,
          backgroundColor: M3Color.of(context).primary,
          foregroundColor: M3Color.of(context).onPrimary,
          label: content.archived ? "Unarchive" : "Archive",
        ),
        confirmDismiss: (direction) async {
          switch (direction) {
            case DismissDirection.startToEnd:
              return onDelete!(content);
            case DismissDirection.vertical:
              return false;
            case DismissDirection.horizontal:
              return false;
            case DismissDirection.endToStart:
              if (content.archived) {
                return onUnarchive!(content);
              } else {
                return onArchive!(content);
              }
            case DismissDirection.up:
              return false;
            case DismissDirection.down:
              return false;
            case DismissDirection.none:
              return false;
          }
        },
        child: StoryTile(
          story: content,
          context: context,
          previousStory: storyAt(index - 1),
          itemPadding: itemPadding,
          onRefresh: () => onRefresh(),
          onArchive: onArchive,
          onDelete: onDelete,
          onUnarchive: onUnarchive,
        ),
      );
    }
    return StoryTile(
      story: content,
      context: context,
      previousStory: storyAt(index - 1),
      itemPadding: itemPadding,
      onRefresh: () => onRefresh(),
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
