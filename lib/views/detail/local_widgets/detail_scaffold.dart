import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/mixins/scaffold_end_drawerable_mixin.dart';
import 'package:spooky/utils/mixins/scaffold_toggle_sheetable_mixin.dart';
import 'package:spooky/views/detail/black_out_notifier.dart';
import 'package:spooky/views/detail/detail_view.dart';
import 'package:spooky/views/detail/detail_view_model.dart';
import 'package:spooky/views/detail/local_widgets/detail_insert_page_button.dart';
import 'package:spooky/views/detail/local_widgets/detail_sheet.dart';
import 'package:spooky/views/detail/local_widgets/feeling_button.dart';
import 'package:spooky/views/detail/local_widgets/page_indicator_button.dart';
import 'package:spooky/views/detail/local_widgets/story_tags.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_fade_in.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';
import 'package:spooky/widgets/sp_sections_tiles.dart';
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

class _DetailScaffoldState extends State<DetailScaffold>
    with StatefulMixin, ScaffoldToggleSheetableMixin, ScaffoldEndDrawableMixin {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  GlobalKey<ScaffoldState> get endDrawerScaffoldKey => _scaffoldkey;

  @override
  GlobalKey<ScaffoldState> get sheetScaffoldkey => _scaffoldkey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      key: _scaffoldkey,
      appBar: buildAppBar(),
      body: widget.editorBuilder(),
      endDrawer: buildEndDrawer(context),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  Widget? buildBottomNavigation() {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.readOnlyNotifier,
      child: Material(
        color: Theme.of(context).canvasColor,
        child: Padding(
          padding: EdgeInsets.only(bottom: viewInsets.bottom + mediaQueryPadding.bottom),
          child: ValueListenableBuilder<bool>(
            // quillControllerInitedNotifier is used to
            // update toolbar state once a controller is inited
            valueListenable: widget.viewModel.quillControllerInitedNotifier,
            child: widget.toolbarBuilder(),
            builder: (context, inited, child) {
              return child ?? const SizedBox.shrink();
            },
          ),
        ),
      ),
      builder: (context, readOnly, child) {
        return buildSheetVisibilityBuilder(
          child: child,
          builder: (context, sheetOpen, child) {
            return SpCrossFade(
              showFirst: !readOnly && !sheetOpen,
              secondChild: const SizedBox.shrink(),
              firstChild: child!,
            );
          },
        );
      },
    );
  }

  MorphingAppBar buildAppBar() {
    return MorphingAppBar(
      heroTag: DetailView.appBarHeroKey,
      elevation: 0,
      leading: buildLeading(),
      title: const SizedBox(),
      flexibleSpace: buildFlexibleSpace(),
      actions: [
        buildEditButton(),
        DetailInsertPageButton(widget: widget, buildSheetVisibilityBuilder: buildSheetVisibilityBuilder),
        ConfigConstant.sizedBoxW0,
        buildEndDrawerButton(CommunityMaterialIcons.tag),
        if (!context.read<BlackOutNotifier>().blackout) ...[
          ConfigConstant.sizedBoxW0,
          ValueListenableBuilder<String?>(
            valueListenable: widget.viewModel.feelingNotifer,
            builder: (context, feeling, child) {
              return FeelingButton(
                feeling: feeling,
                onPicked: (String feeling) {
                  widget.viewModel.setFeeling(feeling);
                },
              );
            },
          ),
        ],
        ConfigConstant.sizedBoxW0,
        PageIndicatorButton(
          controller: widget.viewModel.pageController,
          pagesCount: widget.viewModel.currentContent.pages?.length ?? 0,
          quillControllerGetter: (page) => widget.viewModel.quillControllers[page],
        ),
        buildMoreButton(),
      ],
    );
  }

  FlexibleSpaceBar buildFlexibleSpace() {
    return FlexibleSpaceBar(
      background: ValueListenableBuilder<bool>(
        valueListenable: widget.readOnlyNotifier,
        builder: (context, readOnly, child) {
          return SpFadeIn(
            duration: ConfigConstant.duration * 2,
            child: Stack(
              children: [
                buildSpBottomSheetListener(builder: (context, toolbarOpened, child) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: widget.hasChangeNotifer,
                    builder: (context, hasChange, _) {
                      Color? color;

                      if (toolbarOpened) {
                        color = Theme.of(context).appBarTheme.backgroundColor;
                      } else if (hasChange) {
                        color = M3Color.of(context).readOnly.surface5;
                      } else if (readOnly) {
                        color = M3Color.of(context).background;
                      } else {
                        color = Theme.of(context).appBarTheme.backgroundColor;
                      }

                      return AnimatedContainer(
                        color: color,
                        duration: ConfigConstant.fadeDuration,
                      );
                    },
                  );
                }),
                const Positioned.fill(
                  top: null,
                  child: Divider(height: 1),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildEditButton() {
    if (widget.viewModel.currentStory.type != PathType.docs) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder<bool>(
      valueListenable: widget.readOnlyNotifier,
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.hasChangeNotifer,
        builder: (context, hasChange, child) {
          return Icon(
            Icons.save,
            size: hasChange ? 24 : null,
            color: hasChange ? M3Color.of(context).primary : null,
          );
        },
      ),
      builder: (context, readOnly, child) {
        return SpIconButton(
          onPressed: () async {
            widget.readOnlyNotifier.value = !widget.readOnlyNotifier.value;
            bool saving = widget.readOnlyNotifier.value;
            if (saving) {
              await widget.onSave(context);
            }
          },
          icon: SpAnimatedIcons(
            showFirst: readOnly,
            duration: ConfigConstant.duration * 1.5,
            firstChild: const Icon(Icons.edit),
            secondChild: child!,
          ),
        );
      },
    );
  }

  Widget buildLeading() {
    return SpPopButton(
      onPressed: () {
        if (isSpBottomSheetOpenNotifer.value) {
          toggleSpBottomSheet();
        } else {
          Navigator.maybePop(context);
        }
      },
    );
  }

  @override
  Widget buildEndDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ...SpSectionsTiles.divide(
            context: context,
            sections: [
              SpSectionContents(
                headline: tr("section.tags"),
                leadingIcon: CommunityMaterialIcons.tag,
                tiles: [
                  StoryTags(
                    selectedTagsIds: widget.viewModel.currentStory.tags ?? [],
                    onUpdated: (List<int> ids) {
                      widget.viewModel.setTagIds(ids);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSheet(BuildContext context) {
    return DetailSheet(
      viewModel: widget.viewModel,
      toggleSpBottomSheet: toggleSpBottomSheet,
      isSpBottomSheetOpenNotifer: isSpBottomSheetOpenNotifer,
      readOnlyNotifier: widget.readOnlyNotifier,
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
}
