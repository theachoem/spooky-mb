import 'package:flutter/material.dart';

class SpPopMenuItem {
  final String title;
  final String? subtitle;
  final bool selected;
  final void Function()? onPressed;
  IconData? leadingIconData;
  IconData? trailingIconData;

  SpPopMenuItem({
    required this.title,
    this.onPressed,
    this.selected = false,
    this.leadingIconData,
    this.trailingIconData,
    this.subtitle,
  });
}

class SpPopupMenuButton extends StatefulWidget {
  const SpPopupMenuButton({
    super.key,
    required this.builder,
    required this.items,
    this.fromAppBar = false,
    this.dxGetter,
    this.dyGetter,
    this.onDimissed,
    this.smartDx = false,
  });

  /// show from left/right or dx
  /// base on touch position offset.
  /// `dx, dyGetter` is optional now.
  final bool smartDx;
  final bool fromAppBar;
  final Widget Function(void Function() callback) builder;
  final List<SpPopMenuItem> Function(BuildContext context) items;
  final void Function(SpPopMenuItem?)? onDimissed;

  final double Function(double dx)? dxGetter;
  final double Function(double dy)? dyGetter;

  @override
  State<SpPopupMenuButton> createState() => _SpPopupMenuButtonState();
}

class _SpPopupMenuButtonState extends State<SpPopupMenuButton> {
  RenderBox? overlayBox;
  RenderBox? childBox;

  Offset? childPosition;
  Offset? tapPosition;

  Size? get childSize => childBox?.size;
  Size get screenSize => MediaQuery.of(context).size;

  RelativeRect? get relativeRect {
    if (childPosition == null || childSize == null || overlayBox == null) return null;
    return RelativeRect.fromSize(
      Rect.fromCenter(center: childPosition!, width: childSize!.width, height: childSize!.height),
      overlayBox!.size,
    );
  }

  double dxGetter(double dx) {
    if (widget.dxGetter != null) return widget.dxGetter!(dx);
    return dx;
  }

  double dyGetter(double dy) {
    if (widget.dyGetter != null) return widget.dyGetter!(dy);
    return dy;
  }

  void cacheSize(BuildContext context) {
    overlayBox ??= Overlay.of(context).context.findRenderObject() as RenderBox;
    childBox = context.findRenderObject() as RenderBox;

    childPosition = childBox?.localToGlobal(Offset.zero);

    if (widget.fromAppBar) {
      if (childPosition!.dx >= screenSize.width / 2) {
        childPosition = Offset(screenSize.width, 0);
      } else {
        childPosition = const Offset(0, 0);
      }
    } else {
      if (widget.smartDx && tapPosition != null) {
        childPosition = Offset(
          tapPosition!.dx > screenSize.width / 2 ? screenSize.width : 0.0,
          dyGetter(childPosition!.dy),
        );
      } else {
        childPosition = Offset(
          dxGetter(childPosition!.dx),
          dyGetter(childPosition!.dy),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTapDown: (detail) {
        tapPosition = detail.localPosition;
      },
      onPanDown: (detail) {
        tapPosition = detail.localPosition;
      },
      child: widget.builder(() async {
        cacheSize(context);
        if (relativeRect == null) return;

        SpPopMenuItem? result = await showMenu<SpPopMenuItem>(
          context: context,
          position: relativeRect!,
          items: widget.items(context).map((e) => buildItem(e)).toList(),
        );

        if (result?.onPressed != null) result!.onPressed!();
        if (widget.onDimissed != null) widget.onDimissed!(result);
      }),
    );
  }

  PopupMenuItem<SpPopMenuItem> buildItem(SpPopMenuItem e) {
    return PopupMenuItem<SpPopMenuItem>(
      value: e,
      child: ListTile(
        selected: e.selected,
        leading: e.leadingIconData != null
            ? Container(
                width: 40,
                alignment: Alignment.center,
                child: Icon(e.leadingIconData),
              )
            : null,
        title: Text(e.title),
        trailing: e.trailingIconData != null ? Icon(e.trailingIconData) : null,
        subtitle: e.subtitle != null ? Text(e.subtitle!) : null,
      ),
    );
  }
}
