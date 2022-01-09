import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/file_manager/archive_manager.dart';
import 'package:spooky/core/file_manager/base_fm_constructor_mixin.dart';
import 'package:spooky/core/file_manager/delete_manager.dart';
import 'package:spooky/core/file_manager/docs_manager.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/ui/views/detail/detail_view_model.dart';
import 'package:spooky/ui/views/detail/local_mixins/detail_view_mixin.dart';
import 'package:spooky/ui/views/file_manager/file_manager_view.dart';
import 'package:spooky/ui/widgets/sp_animated_icon.dart';
import 'package:spooky/ui/widgets/sp_cross_fade.dart';
import 'package:spooky/ui/widgets/sp_icon_button.dart';
import 'package:spooky/ui/widgets/sp_pop_button.dart';
import 'package:spooky/ui/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/scaffold_state_mixin.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';
import 'package:spooky/core/route/router.dart' as route;
import 'package:swipeable_page_route/swipeable_page_route.dart';

class DetailScaffold extends StatefulWidget {
  const DetailScaffold({
    Key? key,
    required this.titleBuilder,
    required this.editorBuilder,
    required this.readOnlyNotifier,
    required this.hasChangeNotifer,
    required this.onSave,
    required this.viewModel,
  }) : super(key: key);

  final Widget Function(GlobalKey<ScaffoldState>) titleBuilder;
  final Widget Function(GlobalKey<ScaffoldState>) editorBuilder;
  final ValueNotifier<bool> readOnlyNotifier;
  final ValueNotifier<bool> hasChangeNotifer;
  final Future<void> Function(BuildContext context) onSave;
  final DetailViewModel viewModel;

  @override
  State<DetailScaffold> createState() => _DetailScaffoldState();
}

class _DetailScaffoldState extends State<DetailScaffold> with StatefulMixin, ScaffoldStateMixin, DetailViewMixn {
  final ArchiveManager archiveManager = ArchiveManager();
  final DeleteManager deleteManager = DeleteManager();

  @override
  void initState() {
    super.initState();
    readOnlyAfterAnimatedNotifer = ValueNotifier(widget.readOnlyNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      extendBody: true,
      appBar: buildAppBar(),
      resizeToAvoidBottomInset: false,
      floatingActionButton: buildBypassFAB(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          widget.editorBuilder(scaffoldkey),
          buildFloatActionButton(mediaQueryPadding),
        ],
      ),
    );
  }

  MorphingAppBar buildAppBar() {
    List<SpPopMenuItem> items = [
      SpPopMenuItem(
        title: "Changes History",
        leadingIconData: Icons.history,
        onPressed: () async {
          Directory directory = await DocsManager().constructDirectory(widget.viewModel.currentStory);
          context.router.push(route.FileManager(
            directory: directory,
            fileManagerFlow: FileManagerFlow.viewChanges,
          ));
        },
      ),
      if (archiveManager.canArchive(widget.viewModel.currentStory))
        SpPopMenuItem(
          title: "Archive",
          leadingIconData: Icons.archive,
          onPressed: () async {
            await archiveManager.archiveDocument(widget.viewModel.currentStory);
            if (archiveManager.message != null) {
              App.of(context)?.showSpSnackBar(archiveManager.message!.valueToString());
            }
            context.router.pop(widget.viewModel.currentStory);
          },
        ),
      if (archiveManager.canUnarchive(widget.viewModel.currentStory))
        SpPopMenuItem(
          title: "Unarchive",
          leadingIconData: Icons.unarchive,
          onPressed: () async {
            await archiveManager.unarchiveDocument(widget.viewModel.currentStory);
            if (archiveManager.message != null) {
              App.of(context)?.showSpSnackBar(archiveManager.message!.valueToString());
            }
            context.router.pop(widget.viewModel.currentStory);
          },
        ),
      if (deleteManager.canDelete(widget.viewModel.currentStory))
        SpPopMenuItem(
          title: "Delete",
          titleStyle: TextStyle(color: m3Color?.error),
          leadingIconData: Icons.delete,
          onPressed: () async {
            await deleteManager.delete(widget.viewModel.currentStory);
            if (deleteManager.success == true) {
              App.of(context)?.showSpSnackBar("Delete successfully!");
              context.router.pop(widget.viewModel.currentStory);
            } else {
              App.of(context)?.showSpSnackBar(
                deleteManager.error != null ? deleteManager.error.toString() : "Delete unsuccessfully",
              );
            }
          },
        ),
    ];

    return MorphingAppBar(
      leading: const SpPopButton(),
      title: widget.titleBuilder(scaffoldkey),
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
        if (widget.viewModel.currentStory.documentId != null)
          SpPopupMenuButton(
            fromAppBar: true,
            items: items,
            builder: (void Function() callback) {
              return SpIconButton(
                icon: const Icon(Icons.more_vert, key: ValueKey(Icons.more_vert)),
                onPressed: callback,
              );
            },
          ),
      ],
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
    if (widget.viewModel.currentStory.flowType == DetailViewFlow.update &&
        widget.viewModel.currentStory.filePath != null &&
        widget.viewModel.currentStory.filePath != FilePath.docs) {
      return const SizedBox.shrink();
    }
    return Positioned(
      bottom: 0,
      right: 0,
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.readOnlyNotifier,
        child: buildFabEndWidget(context),
        builder: (context, value, endWidget) {
          double bottom = (value ? 0 : kToolbarHeight) + bottomHeight + 16.0;
          double bottomOffset = keyboardHeight + bottomHeight;
          return AnimatedContainer(
            curve: Curves.ease,
            duration: ConfigConstant.duration,
            transform: Matrix4.identity()..translate(-16.0, -bottom),
            padding: EdgeInsets.only(bottom: keyboardHeight == 0 ? 0 : bottomOffset),
            onEnd: () {
              Future.delayed(ConfigConstant.fadeDuration).then((value) {
                readOnlyAfterAnimatedNotifer.value = widget.readOnlyNotifier.value;
              });
            },
            child: endWidget ?? const SizedBox(),
          );
        },
      ),
    );
  }

  Widget buildFabEndWidget(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ValueListenableBuilder<bool>(
        valueListenable: readOnlyAfterAnimatedNotifer,
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
      ),
    );
  }

  @override
  Widget buildSheet(BuildContext context) {
    return Column(
      children: ListTile.divideTiles(context: context, tiles: [
        if (widget.viewModel.currentStory.documentId != null)
          ListTile(
            title: const Text("Changes History"),
            leading: const Icon(Icons.history),
            onTap: () async {
              Directory directory = await DocsManager().constructDirectory(widget.viewModel.currentStory);
              context.router.push(route.FileManager(
                directory: directory,
                fileManagerFlow: FileManagerFlow.viewChanges,
              ));
            },
          ),
      ]).toList(),
    );
  }
}
