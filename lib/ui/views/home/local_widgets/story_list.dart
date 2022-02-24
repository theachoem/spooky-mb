import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/storages/local_storages/sort_type_storage.dart';
import 'package:spooky/core/types/sort_type.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/ui/views/home/local_widgets/story_tile.dart';
import 'package:spooky/ui/widgets/sp_dimissable_background.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';

class StoryList extends StatefulWidget {
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

  @override
  State<StoryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> with ScheduleMixin {
  SortType? sortType;

  StoryModel? storyAt(int index) {
    if (stories?.isNotEmpty == true) {
      if (index >= 0 && stories!.length > index) {
        return stories![index];
      }
    }
    return null;
  }

  List<StoryModel>? get stories {
    List<StoryModel>? _stories = widget.stories;
    switch (sortType) {
      case SortType.oldToNew:
      case null:
        return _stories;
      case SortType.newToOld:
        return _stories?.reversed.toList();
      case SortType.starred:
        _stories?.sort(((a, b) => b.starred == true ? 1 : -1));
        return _stories;
    }
  }

  @override
  void initState() {
    super.initState();
    SortTypeStorage().readEnum().then((value) {
      sortType = value ?? SortType.oldToNew;
      // set state if stories isn't load yet.
      // list will be update on stories loaded
      if (stories != null) {
        setState(() {});
      }
    });
  }

  String sortTitle(SortType? type) {
    switch (type) {
      case SortType.oldToNew:
        return "Old to New";
      case SortType.newToOld:
        return "New to Old";
      case SortType.starred:
        return "Starred";
      case null:
        return "null";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onDelete != null || widget.onUnarchive != null) {
      assert(widget.onDelete != null);
      assert(widget.onUnarchive != null);
    }
    return RefreshIndicator(
      onRefresh: () async {
        Completer completer = Completer();

        scheduleAction(() async {
          SortType? _sortType = await showConfirmationDialog(
            context: context,
            title: "Reorder Your Stories",
            initialSelectedActionKey: sortType,
            actions: [
              AlertDialogAction(
                key: SortType.newToOld,
                label: sortTitle(SortType.newToOld),
              ),
              AlertDialogAction(
                key: SortType.starred,
                label: sortTitle(SortType.starred),
              ),
              AlertDialogAction(
                key: SortType.oldToNew,
                label: sortTitle(SortType.oldToNew),
              ),
            ].map((e) {
              return AlertDialogAction<SortType>(
                key: e.key,
                isDefaultAction: e.key == sortType,
                label: e.label,
              );
            }).toList(),
          );

          if (_sortType != null) {
            setState(() {
              sortType = _sortType;
              SortTypeStorage().writeEnum(sortType!);
            });
          }

          completer.complete(1);
        });

        await completer.future;
        return await widget.onRefresh();
      },
      child: Stack(
        children: [
          ListView.separated(
            itemCount: stories?.length ?? 0,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) {
              return buildAnimatedTileWrapper(
                child: Divider(
                  indent: 16 + 20 + 16 + 4 + 16,
                  color: M3Color.of(context).secondary.m3Opacity.opacity016,
                  height: 0,
                ),
              );
            },
            itemBuilder: (context, index) {
              return buildAnimatedTileWrapper(
                child: buildConfiguredTile(index, context),
              );
            },
          ),
          IgnorePointer(
            child: Center(
              child: Visibility(
                visible: sortType == null || stories == null,
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          ),
          IgnorePointer(
            child: Visibility(
              visible: stories?.isEmpty == true,
              child: Container(
                alignment: Alignment.center,
                child: Text(widget.emptyMessage),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAnimatedTileWrapper({required Widget child}) {
    return TweenAnimationBuilder<int>(
      key: UniqueKey(),
      duration: ConfigConstant.duration,
      tween: IntTween(begin: 0, end: 1),
      child: child,
      builder: (BuildContext context, int value, Widget? child) {
        return AnimatedContainer(
          duration: ConfigConstant.duration,
          transform: Matrix4.identity()..translate(0.0, value == 1 ? 0 : -ConfigConstant.margin2),
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
    if (widget.onDelete != null && widget.onUnarchive != null) {
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
              if (widget.onDelete != null) return widget.onDelete!(content);
              return false;
            case DismissDirection.vertical:
              return false;
            case DismissDirection.horizontal:
              return false;
            case DismissDirection.endToStart:
              if (widget.onDelete != null) return widget.onUnarchive!(content);
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
          itemPadding: widget.itemPadding,
          onRefresh: () => widget.onRefresh(),
        ),
      );
    }
    return StoryTile(
      story: content,
      context: context,
      previousStory: storyAt(index - 1),
      itemPadding: widget.itemPadding,
      onRefresh: () => widget.onRefresh(),
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
