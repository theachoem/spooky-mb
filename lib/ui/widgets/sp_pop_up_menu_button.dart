import 'package:flutter/material.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';

class SpPopMenuItem {
  final String title;
  final String? subtitle;
  final void Function()? onPressed;
  final TextStyle? titleStyle;
  IconData? leadingIconData;

  SpPopMenuItem({
    required this.title,
    this.onPressed,
    this.titleStyle,
    this.leadingIconData,
    this.subtitle,
  });
}

class SpPopupMenuButton extends StatefulWidget {
  const SpPopupMenuButton({
    Key? key,
    required this.builder,
    required this.items,
    this.fromAppBar = false,
    this.dx,
    this.dy,
    this.onDimissed,
  }) : super(key: key);

  final bool fromAppBar;
  final Widget Function(void Function() callback) builder;
  final List<SpPopMenuItem> Function(BuildContext context) items;
  final void Function(SpPopMenuItem?)? onDimissed;
  final double? dx;
  final double? dy;

  @override
  State<SpPopupMenuButton> createState() => _SpPopupMenuButtonState();
}

class _SpPopupMenuButtonState extends State<SpPopupMenuButton> with StatefulMixin {
  RenderBox? overlay;
  Offset? childPosition;
  Size? childSize;

  GlobalKey<RectGetterState> globalKey = RectGetter.createGlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      RenderObject? renderObject = Overlay.of(context)?.context.findRenderObject();
      if (renderObject is RenderBox) overlay = renderObject;
      setChildPosition();
    });
  }

  RelativeRect? get relativeRect {
    if (childPosition == null || childSize == null) return null;
    return RelativeRect.fromSize(
      Rect.fromCenter(
        center: childPosition!,
        width: childSize!.width,
        height: childSize!.height,
      ),
      overlay!.size,
    );
  }

  void setChildPosition() {
    Rect? rect = RectGetter.getRectFromKey(globalKey);
    childPosition = rect?.center;
    childSize = rect?.size;
    if (widget.fromAppBar) {
      if (childPosition!.dx >= screenSize.width / 2) {
        childPosition = Offset(screenSize.width, 0);
      } else {
        childPosition = const Offset(0, 0);
      }
    } else {
      childPosition = Offset(widget.dx ?? childPosition!.dx, widget.dy ?? childPosition!.dy);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fromAppBar) {
      assert(widget.dx == null);
      assert(widget.dy == null);
    }
    return RectGetter(
      key: globalKey,
      child: widget.builder(() async {
        if (relativeRect == null) return;
        SpPopMenuItem? result = await showMenu<SpPopMenuItem>(
          context: context,
          position: relativeRect!,
          elevation: 2.0,
          shape: RoundedRectangleBorder(borderRadius: ConfigConstant.circlarRadius1),
          items: widget.items(context).map((e) => buildItem(e)).toList(),
        );
        if (result?.onPressed != null) result!.onPressed!();
        if (widget.onDimissed != null) widget.onDimissed!(result);
      }),
    );
  }

  PopupMenuItem<SpPopMenuItem> buildItem(SpPopMenuItem e) {
    return PopupMenuItem<SpPopMenuItem>(
      padding: EdgeInsets.zero,
      onTap: () => Navigator.maybePop(context),
      value: e,
      child: ListTile(
        leading: e.leadingIconData != null
            ? Container(
                width: 40,
                alignment: Alignment.center,
                child: Icon(e.leadingIconData, color: e.titleStyle?.color),
              )
            : null,
        title: Text(e.title, textAlign: TextAlign.left),
        subtitle: e.subtitle != null ? Text(e.subtitle!, textAlign: TextAlign.left) : null,
      ),
    );
  }
}
