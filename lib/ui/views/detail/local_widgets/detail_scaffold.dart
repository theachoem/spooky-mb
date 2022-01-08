import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/file_manager/docs_manager.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/ui/views/detail/detail_view_model.dart';
import 'package:spooky/ui/views/detail/local_mixins/detail_view_mixin.dart';
import 'package:spooky/ui/views/file_manager/file_manager_view.dart';
import 'package:spooky/ui/widgets/sp_animated_icon.dart';
import 'package:spooky/ui/widgets/sp_cross_fade.dart';
import 'package:spooky/ui/widgets/sp_icon_button.dart';
import 'package:spooky/ui/widgets/sp_pop_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/scaffold_state_mixin.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';
import 'package:spooky/core/route/router.dart' as route;

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

  final Widget Function(GlobalKey<ScaffoldState>) titleBuilder;
  final Widget Function(GlobalKey<ScaffoldState>) editorBuilder;
  final Widget Function(GlobalKey<ScaffoldState>) toolbarBuilder;
  final ValueNotifier<bool> readOnlyNotifier;
  final ValueNotifier<bool> hasChangeNotifer;
  final Future<DocsManager> Function() onSave;
  final DetailViewModel viewModel;

  @override
  State<DetailScaffold> createState() => _DetailScaffoldState();
}

class _DetailScaffoldState extends State<DetailScaffold> with StatefulMixin, ScaffoldStateMixin, DetailViewMixn {
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
          Column(
            children: [
              Expanded(
                child: widget.editorBuilder(scaffoldkey),
              ),
              buildAdditionBottomPadding(),
            ],
          ),
          buildToolbar(context, mediaQueryPadding),
          buildFloatActionButton(mediaQueryPadding),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: const SpPopButton(),
      title: widget.titleBuilder(scaffoldkey),
      actions: [
        buildSpBottomSheetListener(
          builder: (context, isSpBottomSheetOpen, _) {
            return SpIconButton(
              icon: SpAnimatedIcons(
                firstChild: const Icon(Icons.more_vert, key: ValueKey(Icons.more_vert)),
                secondChild: const Icon(Icons.clear, key: ValueKey(Icons.clear)),
                showFirst: !isSpBottomSheetOpen,
              ),
              onPressed: () {
                toggleSpBottomSheet();
              },
            );
          },
        )
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

  // spacing when toolbar is opened
  Widget buildAdditionBottomPadding() {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.readOnlyNotifier,
      builder: (context, value, child) {
        double height = value ? 0 : ConfigConstant.objectHeight1 + bottomHeight;
        return SizedBox(height: height + keyboardHeight);
      },
    );
  }

  Widget buildFloatActionButton(EdgeInsets mediaQueryPadding) {
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
                backgroundColor: showFirst ? M3Color.of(context)?.primary : M3Color.of(context)?.secondary,
                foregroundColor: showFirst ? M3Color.of(context)?.onPrimary : M3Color.of(context)?.onSecondary,
                onPressed: () async {
                  widget.readOnlyNotifier.value = !widget.readOnlyNotifier.value;
                  bool saving = widget.readOnlyNotifier.value;
                  if (saving) {
                    DocsManager result = await widget.onSave();
                    if (kDebugMode) {
                      print(result.file?.absolute.path);
                      print(result.success);
                      print(result.error);
                    }
                    Future.delayed(ConfigConstant.fadeDuration).then((value) {
                      if (result.success == true) {
                        App.of(context)?.showSpSnackBar("Saved: ${result.message}");
                      } else {
                        App.of(context)?.showSpSnackBar("Error: ${result.message}");
                      }
                    });
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

  Widget buildToolbar(BuildContext context, EdgeInsets mediaQueryPadding) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.readOnlyNotifier,
        child: AnimatedContainer(
          curve: Curves.ease,
          duration: ConfigConstant.duration * 2,
          color: M3Color.of(context)?.readOnly.surface2,
          padding: EdgeInsets.only(
            bottom: bottomHeight + keyboardHeight + ConfigConstant.margin0,
            top: ConfigConstant.margin0,
          ),
          child: widget.toolbarBuilder(scaffoldkey),
        ),
        builder: (context, value, child) {
          return IgnorePointer(
            ignoring: value,
            child: AnimatedOpacity(
              opacity: value ? 0 : 1,
              duration: ConfigConstant.fadeDuration,
              curve: Curves.ease,
              child: AnimatedContainer(
                curve: Curves.ease,
                duration: ConfigConstant.fadeDuration,
                transform: Matrix4.identity()..translate(0.0, !value ? 0 : kToolbarHeight),
                child: child,
              ),
            ),
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
