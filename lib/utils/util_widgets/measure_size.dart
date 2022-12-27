import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef OnWidgetSizeChange = void Function(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  final OnWidgetSizeChange onChange;
  final void Function(Size)? onPerformLayout;

  MeasureSizeRenderObject(
    this.onChange,
    this.onPerformLayout,
  );

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child!.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    if (onPerformLayout != null) onPerformLayout?.call(newSize);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;
  final void Function(Size)? onPerformLayout;

  const MeasureSize({
    Key? key,
    required this.onChange,
    this.onPerformLayout,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange, onPerformLayout);
  }
}
