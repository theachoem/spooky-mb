import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef OnWidgetSizeChange = void Function(Size size);

class _SpMeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  final OnWidgetSizeChange? onChange;
  final void Function(Size)? onPerformLayout;

  _SpMeasureSizeRenderObject(
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
      onChange?.call(newSize);
    });
  }
}

class SpMeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange? onChange;
  final void Function(Size)? onPerformLayout;

  const SpMeasureSize({
    super.key,
    this.onChange,
    this.onPerformLayout,
    required Widget super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _SpMeasureSizeRenderObject(onChange, onPerformLayout);
  }
}
