import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rect_getter/rect_getter.dart';

mixin OverlayRenderBoxMixin<T extends StatefulWidget> on State<T> {
  final GlobalKey<RectGetterState> globalKey = RectGetter.createGlobalKey();

  RenderBox? overlay;
  Offset? childPosition;
  Size? childSize;

  bool get fromAppBar => false;
  double? get overridedDx => null;
  double? get overridedDy => null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderObject? renderObject = Overlay.of(context)?.context.findRenderObject();
      if (renderObject == null) {
        if (kDebugMode) {
          throw ErrorSummary("Please insert key");
        }
      }
      if (renderObject is RenderBox) overlay = renderObject;
      _setChildPosition();
    });
  }

  void _setChildPosition() {
    var screenSize = MediaQuery.of(context).size;
    Rect? rect = RectGetter.getRectFromKey(globalKey);
    childPosition = rect?.center;
    childSize = rect?.size;
    if (fromAppBar) {
      if (childPosition!.dx >= screenSize.width / 2) {
        childPosition = Offset(screenSize.width, 0);
      } else {
        childPosition = const Offset(0, 0);
      }
    } else {
      childPosition = Offset(
        overridedDx ?? childPosition!.dx,
        overridedDy ?? childPosition!.dy,
      );
    }
  }
}
