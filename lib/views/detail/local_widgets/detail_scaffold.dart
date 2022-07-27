import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/mixins/scaffold_end_drawerable_mixin.dart';
import 'package:spooky/utils/mixins/scaffold_toggle_sheetable_mixin.dart';
import 'package:spooky/views/detail/detail_view.dart';
import 'package:spooky/views/detail/detail_view_model.dart';
import 'package:spooky/views/detail/local_widgets/detail_insert_page_button.dart';
import 'package:spooky/views/detail/local_widgets/detail_sheet.dart';
import 'package:spooky/views/detail/local_widgets/detail_title.dart';
import 'package:spooky/views/detail/local_widgets/page_indicator_button.dart';
import 'package:spooky/views/detail/local_widgets/story_tags.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
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
      floatingActionButton: buildFloatActionButton(mediaQueryPadding),
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
      backgroundColor: M3Color.of(context).background,
      heroTag: DetailView.appBarHeroKey,
      titleSpacing: 8.0,
      elevation: 0,
      leading: buildLeading(),
      title: buildTitle(),
      flexibleSpace: buildFlexibleSpace(),
      actions: [
        DetailInsertPageButton(widget: widget, buildSheetVisibilityBuilder: buildSheetVisibilityBuilder),
        ConfigConstant.sizedBoxW0,
        buildEndDrawerButton(CommunityMaterialIcons.tag),
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

  Widget buildFlexibleSpace() {
    return FlexibleSpaceBar(
      background: buildSheetVisibilityBuilder(
        child: TweenAnimationBuilder<int>(
          duration: ConfigConstant.fadeDuration,
          tween: IntTween(begin: 0, end: 1),
          child: const Divider(height: 1),
          builder: (context, value, child) {
            return AnimatedContainer(
              width: value == 1 ? screenSize.width : 0,
              duration: ConfigConstant.fadeDuration,
              child: child!,
            );
          },
        ),
        builder: (context, isOpen, child) {
          return AnimatedContainer(
            duration: ConfigConstant.fadeDuration,
            alignment: Alignment.bottomCenter,
            color: isOpen ? Theme.of(context).appBarTheme.backgroundColor : M3Color.of(context).background,
            child: child,
          );
        },
      ),
    );
  }

  Widget buildTitle() {
    return buildSheetVisibilityBuilder(
      child: DetailTitle(
        widget: widget,
        context: context,
      ),
      builder: (context, isOpen, child) {
        return IgnorePointer(
          ignoring: isOpen,
          child: SpCrossFade(
            showFirst: !isOpen,
            duration: ConfigConstant.fadeDuration,
            alignment: Alignment.topLeft,
            secondChild: const SizedBox(width: double.infinity),
            firstChild: Wrap(
              children: [child!],
            ),
          ),
        );
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
                headline: "Tags",
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

  Widget buildFloatActionButton(EdgeInsets mediaQueryPadding) {
    if (widget.viewModel.currentStory.type != PathType.docs) {
      return const SizedBox.shrink();
    }
    return buildSheetVisibilityWrapper(buildFabEndWidget(context));
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
                  MessengerService.instance.clearSnackBars();
                }
              },
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
