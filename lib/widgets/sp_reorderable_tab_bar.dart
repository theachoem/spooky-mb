// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Modified by Juniorise Copyright 2022.
// Added reorderable tab on top of previous tab during editing.

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:spooky/views/home/local_widgets/shake_widget.dart';
import 'package:spooky/widgets/sp_animation_controller.dart';

const double _kTabHeight = 46.0;
const double _kTextAndIconTabHeight = 72.0;

class _TabStyle extends AnimatedWidget {
  const _TabStyle({
    required Animation<double> animation,
    required this.selected,
    required this.labelColor,
    required this.unselectedLabelColor,
    required this.labelStyle,
    required this.unselectedLabelStyle,
    required this.child,
  }) : super(listenable: animation);

  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final bool selected;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TabBarTheme tabBarTheme = TabBarTheme.of(context);
    final Animation<double> animation = listenable as Animation<double>;

    // To enable TextStyle.lerp(style1, style2, value), both styles must have
    // the same value of inherit. Force that to be inherit=true here.
    final TextStyle defaultStyle =
        (labelStyle ?? tabBarTheme.labelStyle ?? themeData.primaryTextTheme.bodyText1!).copyWith(inherit: true);
    final TextStyle defaultUnselectedStyle = (unselectedLabelStyle ??
            tabBarTheme.unselectedLabelStyle ??
            labelStyle ??
            themeData.primaryTextTheme.bodyText1!)
        .copyWith(inherit: true);
    final TextStyle textStyle = selected
        ? TextStyle.lerp(defaultStyle, defaultUnselectedStyle, animation.value)!
        : TextStyle.lerp(defaultUnselectedStyle, defaultStyle, animation.value)!;

    final Color selectedColor = labelColor ?? tabBarTheme.labelColor ?? themeData.primaryTextTheme.bodyText1!.color!;
    final Color unselectedColor =
        unselectedLabelColor ?? tabBarTheme.unselectedLabelColor ?? selectedColor.withAlpha(0xB2); // 70% alpha
    final Color color = selected
        ? Color.lerp(selectedColor, unselectedColor, animation.value)!
        : Color.lerp(unselectedColor, selectedColor, animation.value)!;

    return DefaultTextStyle(
      style: textStyle.copyWith(color: color),
      child: IconTheme.merge(
        data: IconThemeData(
          size: 24.0,
          color: color,
        ),
        child: child,
      ),
    );
  }
}

typedef _LayoutCallback = void Function(List<double> xOffsets, TextDirection textDirection, double width);

class _TabLabelBarRenderer extends RenderFlex {
  _TabLabelBarRenderer({
    required super.direction,
    required super.mainAxisSize,
    required super.mainAxisAlignment,
    required super.crossAxisAlignment,
    required TextDirection super.textDirection,
    required super.verticalDirection,
    required this.onPerformLayout,
  });

  _LayoutCallback onPerformLayout;

  @override
  void performLayout() {
    super.performLayout();
    // xOffsets will contain childCount+1 values, giving the offsets of the
    // leading edge of the first tab as the first value, of the leading edge of
    // the each subsequent tab as each subsequent value, and of the trailing
    // edge of the last tab as the last value.
    RenderBox? child = firstChild;
    final List<double> xOffsets = <double>[];
    while (child != null) {
      final FlexParentData childParentData = child.parentData! as FlexParentData;
      xOffsets.add(childParentData.offset.dx);
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }
    assert(textDirection != null);
    switch (textDirection!) {
      case TextDirection.rtl:
        xOffsets.insert(0, size.width);
        break;
      case TextDirection.ltr:
        xOffsets.add(size.width);
        break;
    }
    onPerformLayout(xOffsets, textDirection!, size.width);
  }
}

// This class and its renderer class only exist to report the widths of the tabs
// upon layout. The tab widths are only used at paint time (see _IndicatorPainter)
// or in response to input.
class _TabLabelBar extends Flex {
  _TabLabelBar({
    super.children,
    required this.onPerformLayout,
  }) : super(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
        );

  final _LayoutCallback onPerformLayout;

  @override
  RenderFlex createRenderObject(BuildContext context) {
    return _TabLabelBarRenderer(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: getEffectiveTextDirection(context)!,
      verticalDirection: verticalDirection,
      onPerformLayout: onPerformLayout,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _TabLabelBarRenderer renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.onPerformLayout = onPerformLayout;
  }
}

double _indexChangeProgress(TabController controller) {
  final double controllerValue = controller.animation!.value;
  final double previousIndex = controller.previousIndex.toDouble();
  final double currentIndex = controller.index.toDouble();

  // The controller's offset is changing because the user is dragging the
  // TabBarView's PageView to the left or right.
  if (!controller.indexIsChanging) {
    return clampDouble((currentIndex - controllerValue).abs(), 0.0, 1.0);
  }

  // The TabController animation's value is changing from previousIndex to currentIndex.
  return (controllerValue - currentIndex).abs() / (currentIndex - previousIndex).abs();
}

class _IndicatorPainter extends CustomPainter {
  _IndicatorPainter({
    required this.controller,
    required this.indicator,
    required this.indicatorSize,
    required this.tabKeys,
    required _IndicatorPainter? old,
    required this.indicatorPadding,
  }) : super(repaint: controller.animation) {
    if (old != null) {
      saveTabOffsets(old._currentTabOffsets, old._currentTextDirection);
    }
  }

  final TabController controller;
  final Decoration indicator;
  final TabBarIndicatorSize? indicatorSize;
  final EdgeInsetsGeometry indicatorPadding;
  final List<GlobalKey> tabKeys;

  // _currentTabOffsets and _currentTextDirection are set each time TabBar
  // layout is completed. These values can be null when TabBar contains no
  // tabs, since there are nothing to lay out.
  List<double>? _currentTabOffsets;
  List<double>? get currentTabOffsets => _currentTabOffsets;

  TextDirection? _currentTextDirection;

  Rect? _currentRect;
  BoxPainter? _painter;
  bool _needsPaint = false;
  void markNeedsPaint() {
    _needsPaint = true;
  }

  void dispose() {
    _painter?.dispose();
  }

  void saveTabOffsets(List<double>? tabOffsets, TextDirection? textDirection) {
    _currentTabOffsets = tabOffsets;
    _currentTextDirection = textDirection;
  }

  // _currentTabOffsets[index] is the offset of the start edge of the tab at index, and
  // _currentTabOffsets[_currentTabOffsets.length] is the end edge of the last tab.
  int get maxTabIndex => _currentTabOffsets!.length - 2;

  double centerOf(int tabIndex) {
    assert(_currentTabOffsets != null);
    assert(_currentTabOffsets!.isNotEmpty);
    assert(tabIndex >= 0);
    assert(tabIndex <= maxTabIndex);
    return (_currentTabOffsets![tabIndex] + _currentTabOffsets![tabIndex + 1]) / 2.0;
  }

  Rect indicatorRect(Size tabBarSize, int tabIndex) {
    assert(_currentTabOffsets != null);
    assert(_currentTextDirection != null);
    assert(_currentTabOffsets!.isNotEmpty);
    assert(tabIndex >= 0);
    assert(tabIndex <= maxTabIndex);
    double tabLeft, tabRight;
    switch (_currentTextDirection!) {
      case TextDirection.rtl:
        tabLeft = _currentTabOffsets![tabIndex + 1];
        tabRight = _currentTabOffsets![tabIndex];
        break;
      case TextDirection.ltr:
        tabLeft = _currentTabOffsets![tabIndex];
        tabRight = _currentTabOffsets![tabIndex + 1];
        break;
    }

    if (indicatorSize == TabBarIndicatorSize.label) {
      final double tabWidth = tabKeys[tabIndex].currentContext!.size!.width;
      final double delta = ((tabRight - tabLeft) - tabWidth) / 2.0;
      tabLeft += delta;
      tabRight -= delta;
    }

    final EdgeInsets insets = indicatorPadding.resolve(_currentTextDirection);
    final Rect rect = Rect.fromLTWH(tabLeft, 0.0, tabRight - tabLeft, tabBarSize.height);

    if (!(rect.size >= insets.collapsedSize)) {
      throw FlutterError(
        'indicatorPadding insets should be less than Tab Size\n'
        'Rect Size : ${rect.size}, Insets: $insets',
      );
    }
    return insets.deflateRect(rect);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _needsPaint = false;
    _painter ??= indicator.createBoxPainter(markNeedsPaint);

    final double index = controller.index.toDouble();
    final double value = controller.animation!.value;
    final bool ltr = index > value;
    final int from = (ltr ? value.floor() : value.ceil()).clamp(0, maxTabIndex); // ignore_clamp_double_lint
    final int to = (ltr ? from + 1 : from - 1).clamp(0, maxTabIndex); // ignore_clamp_double_lint
    final Rect fromRect = indicatorRect(size, from);
    final Rect toRect = indicatorRect(size, to);
    _currentRect = Rect.lerp(fromRect, toRect, (value - from).abs());
    assert(_currentRect != null);

    final ImageConfiguration configuration = ImageConfiguration(
      size: _currentRect!.size,
      textDirection: _currentTextDirection,
    );
    _painter!.paint(canvas, _currentRect!.topLeft, configuration);
  }

  @override
  bool shouldRepaint(_IndicatorPainter old) {
    return _needsPaint ||
        controller != old.controller ||
        indicator != old.indicator ||
        tabKeys.length != old.tabKeys.length ||
        (!listEquals(_currentTabOffsets, old._currentTabOffsets)) ||
        _currentTextDirection != old._currentTextDirection;
  }
}

class _ChangeAnimation extends Animation<double> with AnimationWithParentMixin<double> {
  _ChangeAnimation(this.controller);

  final TabController controller;

  @override
  Animation<double> get parent => controller.animation!;

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    if (controller.animation != null) {
      super.removeStatusListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    if (controller.animation != null) {
      super.removeListener(listener);
    }
  }

  @override
  double get value => _indexChangeProgress(controller);
}

class _DragAnimation extends Animation<double> with AnimationWithParentMixin<double> {
  _DragAnimation(this.controller, this.index);

  final TabController controller;
  final int index;

  @override
  Animation<double> get parent => controller.animation!;

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    if (controller.animation != null) {
      super.removeStatusListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    if (controller.animation != null) {
      super.removeListener(listener);
    }
  }

  @override
  double get value {
    assert(!controller.indexIsChanging);
    final double controllerMaxValue = (controller.length - 1).toDouble();
    final double controllerValue = clampDouble(controller.animation!.value, 0.0, controllerMaxValue);
    return clampDouble((controllerValue - index.toDouble()).abs(), 0.0, 1.0);
  }
}

// This class, and TabBarScrollController, only exist to handle the case
// where a scrollable TabBar has a non-zero initialIndex. In that case we can
// only compute the scroll position's initial scroll offset (the "correct"
// pixels value) after the TabBar viewport width and scroll limits are known.
class _TabBarScrollPosition extends ScrollPositionWithSingleContext {
  _TabBarScrollPosition({
    required super.physics,
    required super.context,
    required super.oldPosition,
    required this.tabBar,
  }) : super(
          initialPixels: null,
        );

  final SpReorderableTabBarState tabBar;

  bool? _initialViewportDimensionWasZero;

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    bool result = true;
    if (_initialViewportDimensionWasZero != true) {
      // If the viewport never had a non-zero dimension, we just want to jump
      // to the initial scroll position to avoid strange scrolling effects in
      // release mode: In release mode, the viewport temporarily may have a
      // dimension of zero before the actual dimension is calculated. In that
      // scenario, setting the actual dimension would cause a strange scroll
      // effect without this guard because the super call below would starts a
      // ballistic scroll activity.
      _initialViewportDimensionWasZero = viewportDimension != 0.0;
      correctPixels(tabBar._initialScrollOffset(viewportDimension, minScrollExtent, maxScrollExtent));
      result = false;
    }
    return super.applyContentDimensions(minScrollExtent, maxScrollExtent) && result;
  }
}

// This class, and TabBarScrollPosition, only exist to handle the case
// where a scrollable TabBar has a non-zero initialIndex.
class _TabBarScrollController extends ScrollController {
  _TabBarScrollController(this.tabBar);

  final SpReorderableTabBarState tabBar;

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition? oldPosition) {
    return _TabBarScrollPosition(
      physics: physics,
      context: context,
      oldPosition: oldPosition,
      tabBar: tabBar,
    );
  }
}

class _ShakeAnimation extends StatelessWidget {
  const _ShakeAnimation({
    Key? key,
    required this.child,
    required this.index,
  }) : super(key: key);

  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ShakeWidget(
      shakeConstant: ShakeLittleConstant1(),
      onController: onController,
      duration: const Duration(seconds: 3),
      child: child,
    );
  }

  void onController(SpAnimationController controller) {
    Future.delayed(const Duration(milliseconds: 100) * (index.isEven ? 1 : 0)).then((_) {
      if (controller.disposed) return;
      controller.repeat();
    });
  }
}

class SpReorderableTabBar extends StatefulWidget implements PreferredSizeWidget {
  const SpReorderableTabBar({
    super.key,
    required this.tabs,
    required this.onReorder,
    this.controller,
    this.padding,
    this.indicatorColor,
    this.automaticIndicatorColorAdjustment = true,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicator,
    this.indicatorSize,
    this.labelColor,
    this.labelStyle,
    this.labelPadding,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.overlayColor,
    this.mouseCursor,
    this.enableFeedback,
    this.onTap,
    this.onLongPress,
    this.physics,
    this.splashFactory,
    this.splashBorderRadius,
    this.onContext,
    this.reorderable,
  }) : assert(indicator != null || (indicatorWeight > 0.0));

  final bool Function(int index)? reorderable;
  final void Function(BuildContext context)? onContext;
  final void Function(int oldIndex, int newIndex) onReorder;
  final List<Widget> tabs;
  final TabController? controller;
  final EdgeInsetsGeometry? padding;
  final Color? indicatorColor;
  final double indicatorWeight;
  final EdgeInsetsGeometry indicatorPadding;
  final Decoration? indicator;
  final bool automaticIndicatorColorAdjustment;
  final TabBarIndicatorSize? indicatorSize;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? labelPadding;
  final TextStyle? unselectedLabelStyle;
  final MaterialStateProperty<Color?>? overlayColor;
  final DragStartBehavior dragStartBehavior;
  final MouseCursor? mouseCursor;
  final bool? enableFeedback;
  final ValueChanged<int>? onTap;
  final void Function(BuildContext? context, int index)? onLongPress;
  final ScrollPhysics? physics;
  final InteractiveInkFeatureFactory? splashFactory;
  final BorderRadius? splashBorderRadius;

  @override
  Size get preferredSize {
    double maxHeight = _kTabHeight;
    for (final Widget item in tabs) {
      if (item is PreferredSizeWidget) {
        final double itemHeight = item.preferredSize.height;
        maxHeight = math.max(itemHeight, maxHeight);
      }
    }
    return Size.fromHeight(maxHeight + indicatorWeight);
  }

  bool get tabHasTextAndIcon {
    for (final Widget item in tabs) {
      if (item is PreferredSizeWidget) {
        if (item.preferredSize.height == _kTextAndIconTabHeight) {
          return true;
        }
      }
    }
    return false;
  }

  static SpReorderableTabBarState? of(BuildContext context) {
    return context.findAncestorStateOfType<SpReorderableTabBarState>();
  }

  @override
  State<SpReorderableTabBar> createState() => SpReorderableTabBarState();
}

class SpReorderableTabBarState extends State<SpReorderableTabBar> {
  late ScrollController _scrollController;
  TabController? _controller;
  _IndicatorPainter? _indicatorPainter;
  int? _currentIndex;
  late double _tabStripWidth;
  late List<GlobalKey> _tabKeys;
  bool _debugHasScheduledValidTabsCountCheck = false;

  bool _editing = false;
  bool get editing => _editing;
  void setEditing(bool editing) {
    if (_editing == editing) return;

    setState(() {
      _editing = editing;
      double offset = _scrollController.offset;
      _scrollController = ScrollController(initialScrollOffset: offset);
    });
  }

  @override
  void initState() {
    super.initState();
    // If indicatorSize is TabIndicatorSize.label, _tabKeys[i] is used to find
    // the width of tab widget i. See _IndicatorPainter.indicatorRect().
    _tabKeys = widget.tabs.map((Widget tab) => GlobalKey()).toList();

    // handle some case and get init tab state position
    _scrollController = _TabBarScrollController(this);
    _onContext();
  }

  Decoration get _indicator {
    if (widget.indicator != null) {
      return widget.indicator!;
    }
    final TabBarTheme tabBarTheme = TabBarTheme.of(context);
    if (tabBarTheme.indicator != null) {
      return tabBarTheme.indicator!;
    }

    Color color = widget.indicatorColor ?? Theme.of(context).indicatorColor;
    // ThemeData tries to avoid this by having indicatorColor avoid being the
    // primaryColor. However, it's possible that the tab bar is on a
    // Material that isn't the primaryColor. In that case, if the indicator
    // color ends up matching the material's color, then this overrides it.
    // When that happens, automatic transitions of the theme will likely look
    // ugly as the indicator color suddenly snaps to white at one end, but it's
    // not clear how to avoid that any further.
    //
    // The material's color might be null (if it's a transparency). In that case
    // there's no good way for us to find out what the color is so we don't.
    //
    // .TODO(xu-baolin): Remove automatic adjustment to white color indicator
    // with a better long-term solution.
    // https://github.com/flutter/flutter/pull/68171#pullrequestreview-517753917
    if (widget.automaticIndicatorColorAdjustment && color.value == Material.of(context)?.color?.value) {
      color = Colors.white;
    }

    return UnderlineTabIndicator(
      borderSide: BorderSide(
        width: widget.indicatorWeight,
        color: color,
      ),
    );
  }

  // If the TabBar is rebuilt with a new tab controller, the caller should
  // dispose the old one. In that case the old controller's animation will be
  // null and should not be accessed.
  bool get _controllerIsValid => _controller?.animation != null;

  void _updateTabController() {
    final TabController? newController = widget.controller ?? DefaultTabController.of(context);
    assert(() {
      if (newController == null) {
        throw FlutterError(
          'No TabController for ${widget.runtimeType}.\n'
          'When creating a ${widget.runtimeType}, you must either provide an explicit '
          'TabController using the "controller" property, or you must ensure that there '
          'is a DefaultTabController above the ${widget.runtimeType}.\n'
          'In this case, there was neither an explicit controller nor a default controller.',
        );
      }
      return true;
    }());

    if (newController == _controller) {
      return;
    }

    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
      _controller!.removeListener(_handleTabControllerTick);
    }
    _controller = newController;
    if (_controller != null) {
      _controller!.animation!.addListener(_handleTabControllerAnimationTick);
      _controller!.addListener(_handleTabControllerTick);
      _currentIndex = _controller!.index;
    }
  }

  void _initIndicatorPainter() {
    _indicatorPainter = !_controllerIsValid
        ? null
        : _IndicatorPainter(
            controller: _controller!,
            indicator: _indicator,
            indicatorSize: widget.indicatorSize ?? TabBarTheme.of(context).indicatorSize,
            indicatorPadding: widget.indicatorPadding,
            tabKeys: _tabKeys,
            old: _indicatorPainter,
          );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterial(context));
    _updateTabController();
    _initIndicatorPainter();
  }

  @override
  void didUpdateWidget(SpReorderableTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController();
      _initIndicatorPainter();
    } else if (widget.indicatorColor != oldWidget.indicatorColor ||
        widget.indicatorWeight != oldWidget.indicatorWeight ||
        widget.indicatorSize != oldWidget.indicatorSize ||
        widget.indicator != oldWidget.indicator) {
      _initIndicatorPainter();
    }

    if (widget.tabs.length > _tabKeys.length) {
      final int delta = widget.tabs.length - _tabKeys.length;
      _tabKeys.addAll(List<GlobalKey>.generate(delta, (int n) => GlobalKey()));
    } else if (widget.tabs.length < _tabKeys.length) {
      _tabKeys.removeRange(widget.tabs.length, _tabKeys.length);
    }
  }

  @override
  void dispose() {
    _indicatorPainter!.dispose();

    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
      _controller!.removeListener(_handleTabControllerTick);
    }

    _controller = null;
    _scrollController.dispose();

    // We don't own the _controller Animation, so it's not disposed here.
    super.dispose();
  }

  int get maxTabIndex => _indicatorPainter!.maxTabIndex;

  double _tabScrollOffset(int index, double viewportWidth, double minExtent, double maxExtent) {
    double tabCenter = _indicatorPainter!.centerOf(index);
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        tabCenter = _tabStripWidth - tabCenter;
        break;
      case TextDirection.ltr:
        break;
    }
    return clampDouble(tabCenter - viewportWidth / 2.0, minExtent, maxExtent);
  }

  double _tabCenteredScrollOffset(int index) {
    final ScrollPosition position = _scrollController.position;
    return _tabScrollOffset(index, position.viewportDimension, position.minScrollExtent, position.maxScrollExtent);
  }

  double _initialScrollOffset(double viewportWidth, double minExtent, double maxExtent) {
    return _tabScrollOffset(_currentIndex!, viewportWidth, minExtent, maxExtent);
  }

  void _scrollToCurrentIndex() {
    final double offset = _tabCenteredScrollOffset(_currentIndex!);
    _scrollController.animateTo(offset, duration: kTabScrollDuration, curve: Curves.ease);
  }

  void _scrollToControllerValue() {
    final double? leadingPosition = _currentIndex! > 0 ? _tabCenteredScrollOffset(_currentIndex! - 1) : null;
    final double middlePosition = _tabCenteredScrollOffset(_currentIndex!);
    final double? trailingPosition = _currentIndex! < maxTabIndex ? _tabCenteredScrollOffset(_currentIndex! + 1) : null;

    final double index = _controller!.index.toDouble();
    final double value = _controller!.animation!.value;
    final double offset;
    if (value == index - 1.0) {
      offset = leadingPosition ?? middlePosition;
    } else if (value == index + 1.0) {
      offset = trailingPosition ?? middlePosition;
    } else if (value == index) {
      offset = middlePosition;
    } else if (value < index) {
      offset = leadingPosition == null ? middlePosition : lerpDouble(middlePosition, leadingPosition, index - value)!;
    } else {
      offset = trailingPosition == null ? middlePosition : lerpDouble(middlePosition, trailingPosition, value - index)!;
    }

    _scrollController.jumpTo(offset);
  }

  void _handleTabControllerAnimationTick() {
    assert(mounted);
    if (!_controller!.indexIsChanging) {
      // Sync the TabBar's scroll position with the TabBarView's PageView.
      _currentIndex = _controller!.index;
      _scrollToControllerValue();
    }
  }

  void _handleTabControllerTick() {
    if (_controller!.index != _currentIndex) {
      _currentIndex = _controller!.index;
      _scrollToCurrentIndex();
    }
    setState(() {
      // Rebuild the tabs after a (potentially animated) index change
      // has completed.
    });
  }

  // Called each time layout completes.
  void _saveTabOffsets(List<double> tabOffsets, TextDirection textDirection, double width) {
    _tabStripWidth = width;
    _indicatorPainter?.saveTabOffsets(tabOffsets, textDirection);
  }

  void _handleTap(int index) {
    assert(index >= 0 && index < widget.tabs.length);
    _controller!.animateTo(index);
    widget.onTap?.call(index);
  }

  void _handleLongPress(BuildContext? context, int index) {
    widget.onLongPress?.call(context, index);
  }

  Widget _buildStyledTab(Widget child, bool selected, Animation<double> animation) {
    return _TabStyle(
      animation: animation,
      selected: selected,
      labelColor: widget.labelColor,
      unselectedLabelColor: widget.unselectedLabelColor,
      labelStyle: widget.labelStyle,
      unselectedLabelStyle: widget.unselectedLabelStyle,
      child: child,
    );
  }

  bool _debugScheduleCheckHasValidTabsCount() {
    if (_debugHasScheduledValidTabsCountCheck) {
      return true;
    }
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      _debugHasScheduledValidTabsCountCheck = false;
      if (!mounted) {
        return;
      }
      assert(() {
        if (_controller!.length != widget.tabs.length) {
          throw FlutterError(
            "Controller's length property (${_controller!.length}) does not match the "
            "number of tabs (${widget.tabs.length}) present in TabBar's tabs property.",
          );
        }
        return true;
      }());
    });
    _debugHasScheduledValidTabsCountCheck = true;
    return true;
  }

  // find current visible & valid context of tab
  void _onContext() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final visibleKeys = _tabKeys.where((element) => element.currentContext != null);
      if (visibleKeys.isNotEmpty && visibleKeys.first.currentContext != null) {
        widget.onContext?.call(visibleKeys.first.currentContext!);
      }
    });
  }

  bool _reorderable(int index) {
    if (widget.reorderable == null) return true;
    return widget.reorderable!.call(index);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    assert(_debugScheduleCheckHasValidTabsCount());

    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    if (_controller!.length == 0) {
      return Container(
        height: _kTabHeight + widget.indicatorWeight,
      );
    }

    final TabBarTheme tabBarTheme = TabBarTheme.of(context);

    final List<Widget> wrappedTabs = List<Widget>.generate(widget.tabs.length, (int index) {
      const double verticalAdjustment = (_kTextAndIconTabHeight - _kTabHeight) / 2.0;
      EdgeInsetsGeometry? adjustedPadding;

      if (widget.tabs[index] is PreferredSizeWidget) {
        final PreferredSizeWidget tab = widget.tabs[index] as PreferredSizeWidget;
        if (widget.tabHasTextAndIcon && tab.preferredSize.height == _kTabHeight) {
          if (widget.labelPadding != null || tabBarTheme.labelPadding != null) {
            adjustedPadding = (widget.labelPadding ?? tabBarTheme.labelPadding!)
                .add(const EdgeInsets.symmetric(vertical: verticalAdjustment));
          } else {
            adjustedPadding = const EdgeInsets.symmetric(vertical: verticalAdjustment, horizontal: 16.0);
          }
        }
      }

      return Center(
        heightFactor: 1.0,
        child: Padding(
          padding: adjustedPadding ?? widget.labelPadding ?? tabBarTheme.labelPadding ?? kTabLabelPadding,
          child: KeyedSubtree(
            key: _tabKeys[index],
            child: widget.tabs[index],
          ),
        ),
      );
    });

    // If the controller was provided by DefaultTabController and we're part
    // of a Hero (typically the AppBar), then we will not be able to find the
    // controller during a Hero transition. See https://github.com/flutter/flutter/issues/213.
    if (_controller != null) {
      final int previousIndex = _controller!.previousIndex;

      if (_controller!.indexIsChanging) {
        // The user tapped on a tab, the tab controller's animation is running.
        assert(_currentIndex != previousIndex);
        final Animation<double> animation = _ChangeAnimation(_controller!);
        wrappedTabs[_currentIndex!] = _buildStyledTab(wrappedTabs[_currentIndex!], true, animation);
        wrappedTabs[previousIndex] = _buildStyledTab(wrappedTabs[previousIndex], false, animation);
      } else {
        // The user is dragging the TabBarView's PageView left or right.
        final int tabIndex = _currentIndex!;
        final Animation<double> centerAnimation = _DragAnimation(_controller!, tabIndex);
        wrappedTabs[tabIndex] = _buildStyledTab(wrappedTabs[tabIndex], true, centerAnimation);
        if (_currentIndex! > 0) {
          final int tabIndex = _currentIndex! - 1;
          final Animation<double> previousAnimation = ReverseAnimation(_DragAnimation(_controller!, tabIndex));
          wrappedTabs[tabIndex] = _buildStyledTab(wrappedTabs[tabIndex], false, previousAnimation);
        }
        if (_currentIndex! < widget.tabs.length - 1) {
          final int tabIndex = _currentIndex! + 1;
          final Animation<double> nextAnimation = ReverseAnimation(_DragAnimation(_controller!, tabIndex));
          wrappedTabs[tabIndex] = _buildStyledTab(wrappedTabs[tabIndex], false, nextAnimation);
        }
      }
    }

    // Add the tap handler to each tab. If the tab bar is not scrollable,
    // then give all of the tabs equal flexibility so that they each occupy
    // the same share of the tab bar's overall width.
    final int tabCount = widget.tabs.length;
    for (int index = 0; index < tabCount; index += 1) {
      final Set<MaterialState> states = <MaterialState>{
        if (index == _currentIndex) MaterialState.selected,
      };

      final MouseCursor effectiveMouseCursor =
          MaterialStateProperty.resolveAs<MouseCursor?>(widget.mouseCursor, states) ??
              tabBarTheme.mouseCursor?.resolve(states) ??
              MaterialStateMouseCursor.clickable.resolve(states);

      wrappedTabs[index] = InkWell(
        mouseCursor: effectiveMouseCursor,
        onTap: () => _handleTap(index),
        onLongPress: !(_editing || widget.onLongPress == null)
            ? () => _handleLongPress(_tabKeys[index].currentContext, index)
            : null,
        enableFeedback: widget.enableFeedback ?? true,
        overlayColor: widget.overlayColor ?? tabBarTheme.overlayColor,
        splashFactory: widget.splashFactory ?? tabBarTheme.splashFactory,
        borderRadius: widget.splashBorderRadius,
        child: Padding(
          padding: EdgeInsets.only(bottom: widget.indicatorWeight),
          child: Stack(
            children: <Widget>[
              wrappedTabs[index],
              Semantics(
                selected: index == _currentIndex,
                label: localizations.tabLabel(tabIndex: index + 1, tabCount: tabCount),
              ),
            ],
          ),
        ),
      );
    }

    Widget tabBar;
    if (_editing) {
      tabBar = SizedBox(
        height: widget.preferredSize.height,
        child: ReorderableListView(
          dragStartBehavior: widget.dragStartBehavior,
          padding: widget.padding != null
              ? EdgeInsets.symmetric(
                  vertical: widget.padding!.vertical,
                  horizontal: widget.padding!.horizontal / 2,
                )
              : null,
          scrollController: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: widget.physics,
          onReorder: widget.onReorder,
          children: List.generate(
            wrappedTabs.length,
            (index) {
              bool orderable = _reorderable(index);
              return IgnorePointer(
                key: ValueKey(index),
                ignoring: !orderable,
                child: orderable
                    ? _ShakeAnimation(index: index, child: wrappedTabs.elementAt(index))
                    : wrappedTabs.elementAt(index),
              );
            },
          ),
        ),
      );
    } else {
      tabBar = CustomPaint(
        painter: _indicatorPainter,
        child: _TabStyle(
          animation: kAlwaysDismissedAnimation,
          selected: false,
          labelColor: widget.labelColor,
          unselectedLabelColor: widget.unselectedLabelColor,
          labelStyle: widget.labelStyle,
          unselectedLabelStyle: widget.unselectedLabelStyle,
          child: _TabLabelBar(
            onPerformLayout: _saveTabOffsets,
            children: wrappedTabs,
          ),
        ),
      );

      tabBar = SingleChildScrollView(
        dragStartBehavior: widget.dragStartBehavior,
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        padding: widget.padding,
        physics: widget.physics,
        child: tabBar,
      );

      tabBar = Container(
        alignment: Alignment.centerLeft,
        child: tabBar,
      );
    }

    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        _onContext();
        return false;
      },
      child: tabBar,
    );
  }
}
