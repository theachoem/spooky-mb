import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:spooky/views/detail/local_widgets/detail_scaffold.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_icon_button.dart';

class DetailInsertPageButton extends StatelessWidget {
  const DetailInsertPageButton({
    Key? key,
    required this.widget,
    required this.buildSheetVisibilityBuilder,
  }) : super(key: key);

  final DetailScaffold widget;
  final Widget Function({
    required Widget Function(BuildContext, bool, Widget?) builder,
    Widget? child,
  }) buildSheetVisibilityBuilder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.readOnlyNotifier,
      child: SpIconButton(
        icon: const Icon(CommunityMaterialIcons.format_page_break),
        key: const ValueKey(CommunityMaterialIcons.format_page_break),
        tooltip: "Insert page break",
        onPressed: () {
          widget.viewModel.addPage();
        },
      ),
      builder: (context, value, child) {
        return buildSheetVisibilityBuilder(
          child: child,
          builder: (context, sheetOpen, child) {
            return SpAnimatedIcons(
              showFirst: !widget.readOnlyNotifier.value && !sheetOpen,
              secondChild: const SizedBox.shrink(key: ValueKey("AddPageSizedBox")),
              firstChild: child!,
            );
          },
        );
      },
    );
  }
}
