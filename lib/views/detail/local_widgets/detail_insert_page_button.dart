import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/detail/local_widgets/detail_scaffold.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
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
        tooltip: tr("button.insert_page_break"),
        onPressed: () {
          widget.viewModel.addPage();
        },
      ),
      builder: (context, value, child) {
        return buildSheetVisibilityBuilder(
          child: child,
          builder: (context, sheetOpen, child) {
            return Center(
              child: SpCrossFade(
                alignment: Alignment.center,
                duration: ConfigConstant.duration * 1.5,
                showFirst: !widget.readOnlyNotifier.value && !sheetOpen,
                secondChild: const SizedBox(height: 48),
                firstChild: child!,
              ),
            );
          },
        );
      },
    );
  }
}
