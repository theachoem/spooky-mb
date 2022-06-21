import 'package:spooky/views/detail/detail_view_model.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:flutter/material.dart';
import 'package:spooky/widgets/sp_toolbar/sp_toolbar.dart';

class DetailToolbars extends StatelessWidget {
  const DetailToolbars({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final DetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: viewModel.pageOffsetNotifier,
      child: buildBypassChildren(),
      builder: (context, offset, Widget? child) {
        child as _List;
        if (child.children.isEmpty) return const SizedBox.shrink();
        return ValueListenableBuilder<bool>(
          valueListenable: viewModel.toolbarVisibleNotifier,
          builder: (context, toolbarShouldVisible, _) {
            return Stack(
              children: List.generate(child.children.length, (index) {
                Widget selectedChild = child.children[index];
                double page = viewModel.pageController.page ?? 0.0;
                bool visible = page > index - 0.25 && page < index + 0.25;
                return buildWrapper(
                  visible && toolbarShouldVisible,
                  selectedChild,
                );
              }),
            );
          },
        );
      },
    );
  }

  Widget buildBypassChildren() {
    return _List(
      children: viewModel.quillControllers.values.map((controller) {
        return SpToolbar(
          controller: controller,
        );
        // return editor.QuillToolbar.basic(
        //   controller: controller,
        //   multiRowsDisplay: false,
        //   toolbarIconSize: ConfigConstant.iconSize2,
        // );
      }).toList(),
    );
  }

  Widget buildWrapper(bool visible, Widget child) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: ConfigConstant.fadeDuration,
      curve: Curves.ease,
      child: IgnorePointer(
        ignoring: !visible,
        child: child,
      ),
    );
  }
}

// Bypass children. Used just for get children.
// In value notifier builder, use it on child to avoid rebuild.
class _List extends Widget {
  const _List({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Element createElement() {
    throw UnimplementedError();
  }
}
