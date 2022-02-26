import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/file_manager/managers/archive_file_manager.dart';
import 'package:spooky/core/types/file_path_type.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/ui/views/detail/detail_view_model.dart';
import 'package:spooky/ui/views/detail/local_widgets/page_indicator_button.dart';
import 'package:spooky/ui/widgets/sp_animated_icon.dart';
import 'package:spooky/ui/widgets/sp_cross_fade.dart';
import 'package:spooky/ui/widgets/sp_icon_button.dart';
import 'package:spooky/ui/widgets/sp_pop_button.dart';
import 'package:spooky/ui/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class DetailScaffold extends StatefulWidget {
  const DetailScaffold({
    Key? key,
    required this.titleBuilder,
    required this.editorBuilder,
    required this.toolbarBuilder,
    required this.readOnlyNotifier,
    required this.hasChangeNotifer,
    required this.onSave,
    required this.viewModel,
  }) : super(key: key);

  final Widget Function() titleBuilder;
  final Widget Function() editorBuilder;
  final Widget? Function() toolbarBuilder;
  final ValueNotifier<bool> readOnlyNotifier;
  final ValueNotifier<bool> hasChangeNotifer;
  final Future<void> Function(BuildContext context) onSave;
  final DetailViewModel viewModel;

  @override
  State<DetailScaffold> createState() => _DetailScaffoldState();
}

class _DetailScaffoldState extends State<DetailScaffold> with StatefulMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      floatingActionButton: buildFloatActionButton(mediaQueryPadding),
      body: widget.editorBuilder(),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  Widget? buildBottomNavigation() {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.readOnlyNotifier,
      builder: (context, readOnly, child) {
        return SpCrossFade(
          showFirst: !readOnly,
          secondChild: SizedBox.shrink(),
          firstChild: Material(
            color: Theme.of(context).canvasColor,
            child: Padding(
              padding: EdgeInsets.only(bottom: viewInsets.bottom + mediaQueryPadding.bottom),
              child: ValueListenableBuilder<bool>(
                // quillControllerInitedNotifier is used to
                // update toolbar state once a controller is inited
                valueListenable: widget.viewModel.quillControllerInitedNotifier,
                builder: (context, inited, child) {
                  return widget.toolbarBuilder() ?? SizedBox.shrink();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  MorphingAppBar buildAppBar() {
    return MorphingAppBar(
      leading: const SpPopButton(),
      title: widget.titleBuilder(),
      actions: [
        ValueListenableBuilder<bool>(
          valueListenable: widget.readOnlyNotifier,
          child: SpIconButton(
            icon: Icon(Icons.add_chart),
            key: ValueKey(Icons.add_chart),
            onPressed: () {
              widget.viewModel.addPage();
            },
            tooltip: "Add page",
          ),
          builder: (context, value, child) {
            return SpAnimatedIcons(
              showFirst: !widget.readOnlyNotifier.value,
              secondChild: const SizedBox.shrink(key: ValueKey("AddPageSizedBox")),
              firstChild: child!,
            );
          },
        ),
        ConfigConstant.sizedBoxW0,
        PageIndicatorButton(
          controller: widget.viewModel.pageController,
          pagesCount: widget.viewModel.currentContent.pages?.length ?? 0,
          quillControllerGetter: (page) => widget.viewModel.quillControllers[page],
        ),
        buildMoreVertButton(),
      ],
    );
  }

  ArchiveFileManager manager = ArchiveFileManager();

  Widget buildMoreVertButton() {
    return SpPopupMenuButton(
      fromAppBar: true,
      items: (context) => [
        if ((widget.viewModel.currentContent.pages ?? []).length > 1)
          SpPopMenuItem(
            title: "Manage Pages",
            leadingIconData: Icons.edit,
            onPressed: () async {
              if (widget.viewModel.hasChange) {
                App.of(context)?.showSpSnackBar("Please save document first");
                return;
              }
              ManagePagesArgs arguments = ManagePagesArgs(content: widget.viewModel.currentContent);
              Navigator.of(context).pushNamed(SpRouteConfig.managePages, arguments: arguments).then((value) {
                if (value is StoryContentModel) widget.viewModel.updatePages(value);
              });
            },
          ),
        if (widget.viewModel.flowType == DetailViewFlowType.update && manager.canArchive(widget.viewModel.currentStory))
          SpPopMenuItem(
            title: "Archive",
            leadingIconData: Icons.archive,
            onPressed: () async {
              if (widget.viewModel.hasChange) {
                App.of(context)?.showSpSnackBar("Please save document first");
                return;
              }
              OkCancelResult result = await showOkCancelAlertDialog(
                context: context,
                useRootNavigator: true,
                title: "Are you sure to archive document?",
              );
              switch (result) {
                case OkCancelResult.ok:
                  File? file = await manager.archiveDocument(widget.viewModel.currentStory);
                  if (file != null) {
                    App.of(context)?.showSpSnackBar("Archived!");
                  }
                  Navigator.of(context).maybePop(widget.viewModel.currentStory);
                  break;
                case OkCancelResult.cancel:
                  break;
              }
            },
          ),
        SpPopMenuItem(
          title: "Changes History",
          leadingIconData: Icons.history,
          onPressed: () async {
            if (widget.viewModel.hasChange) {
              App.of(context)?.showSpSnackBar("Please save document first");
              return;
            }
            ChangesHistoryArgs arguments = ChangesHistoryArgs(
              story: widget.viewModel.currentStory,
              onRestorePressed: (content) => widget.viewModel.restore(content.id),
              onDeletePressed: (contentIds) => widget.viewModel.deleteChange(contentIds),
            );
            Navigator.of(context).pushNamed(
              SpRouteConfig.changesHistory,
              arguments: arguments,
            );
          },
        ),
      ],
      onDimissed: (result) {
        if (result == null) {
          FocusScope.of(context).requestFocus();
        }
      },
      builder: (void Function() callback) {
        return SpIconButton(
          icon: const Icon(Icons.more_vert, key: ValueKey(Icons.more_vert)),
          onPressed: () {
            FocusScope.of(context).unfocus();
            callback();
          },
        );
      },
    );
  }

  // invisible FAB's used as fake position for
  // real FAB which is in stack to improve other widget eg. SnackBar.
  Widget buildBypassFAB() {
    return const IgnorePointer(
      child: Opacity(
        opacity: 0,
        child: SizedBox(height: kToolbarHeight),
      ),
    );
  }

  Widget buildFloatActionButton(EdgeInsets mediaQueryPadding) {
    if (widget.viewModel.currentStory.path.filePath != FilePathType.docs) {
      return const SizedBox.shrink();
    }
    return buildFabEndWidget(context);
  }

  Widget buildFabEndWidget(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.readOnlyNotifier,
      builder: (context, value, endWidget) {
        return ValueListenableBuilder<bool>(
          valueListenable: widget.hasChangeNotifer,
          child: SpAnimatedIcons(
            firstChild: const Icon(Icons.edit, key: ValueKey(Icons.edit)),
            secondChild: const Icon(Icons.save, key: ValueKey(Icons.save)),
            showFirst: value,
          ),
          builder: (context, hasChange, icon) {
            bool showFirst = !value && hasChange;
            return FloatingActionButton.extended(
              backgroundColor: showFirst ? M3Color.of(context).primary : M3Color.of(context).secondary,
              foregroundColor: showFirst ? M3Color.of(context).onPrimary : M3Color.of(context).onSecondary,
              onPressed: () async {
                widget.readOnlyNotifier.value = !widget.readOnlyNotifier.value;
                bool saving = widget.readOnlyNotifier.value;
                if (saving) {
                  await widget.onSave(context);
                } else {
                  // clear to avoid snack bar on top of "SAVE" fab.
                  App.of(context)?.clearSpSnackBars();
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              label: SpCrossFade(
                firstChild: const Text("Edit"),
                secondChild: const Text("Save"),
                showFirst: value,
              ),
              icon: icon,
            );
          },
        );
      },
    );
  }
}
