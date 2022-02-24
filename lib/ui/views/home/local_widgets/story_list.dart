import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/ui/views/home/local_widgets/story_tile.dart';
import 'package:spooky/ui/widgets/sp_dimissable_background.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class StoryList extends StatelessWidget {
  const StoryList({
    Key? key,
    required this.onRefresh,
    required this.stories,
    this.emptyMessage = "Empty",
    this.onDelete,
    this.onUnarchive,
    this.itemPadding = const EdgeInsets.all(ConfigConstant.margin2),
  }) : super(key: key);

  final Future<void> Function() onRefresh;
  final Future<bool> Function(StoryModel story)? onDelete;
  final Future<bool> Function(StoryModel story)? onUnarchive;
  final List<StoryModel>? stories;
  final String emptyMessage;
  final EdgeInsets itemPadding;

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
    if (onDelete != null || onUnarchive != null) {
      assert(onDelete != null);
      assert(onUnarchive != null);
    }
    return RefreshIndicator(
      onRefresh: () => onRefresh(),
      child: Stack(
        children: [
          ListView.separated(
            itemCount: stories?.length ?? 0,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) {
              return buildAnimatedTileWrapper(
                index: index,
                child: Divider(
                  indent: 16 + 20 + 16 + 4 + 16,
                  color: M3Color.of(context).secondary.m3Opacity.opacity016,
                  height: 0,
                ),
              );
            },
            itemBuilder: (context, index) {
              return buildAnimatedTileWrapper(
                index: index,
                child: buildConfiguredTile(index, context),
              );
            },
          ),
          IgnorePointer(
            child: Center(
              child: Visibility(
                visible: stories == null,
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          ),
          IgnorePointer(
            child: Visibility(
              visible: stories?.isEmpty == true,
              child: Container(
                alignment: Alignment.center,
                child: Text(emptyMessage),
              ),
            ),
          ),
        ],
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
    if (onDelete != null && onUnarchive != null) {
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
          iconData: Icons.unarchive,
          alignment: Alignment.centerRight,
          backgroundColor: M3Color.of(context).primary,
          foregroundColor: M3Color.of(context).onPrimary,
          label: "Unarchive",
        ),
        confirmDismiss: (direction) async {
          switch (direction) {
            case DismissDirection.startToEnd:
              if (onDelete != null) return onDelete!(content);
              return false;
            case DismissDirection.vertical:
              return false;
            case DismissDirection.horizontal:
              return false;
            case DismissDirection.endToStart:
              if (onDelete != null) return onUnarchive!(content);
              return false;
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
