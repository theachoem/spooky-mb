import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/ui/widgets/sp_cross_fade.dart';
import 'package:spooky/ui/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/constants/util_colors_constant.dart';

/// final map = {
///   0: [0, 1, 2, 3],
///   1: [4, 5, 6, 7],
///   2: [8, 9, 10, 11],
///   3: [12, 13, 14, 15],
///   4: [16, 17, 18, 19],
///   5: [20]
/// };
///
Map<int, List<int>> listToTreeMap(List<dynamic> _list, {int rowLength = 5}) {
  Map<int, List<int>> map = {};
  for (int c = 0; c <= _list.length ~/ rowLength; c++) {
    List<int> children = [];
    for (int r = c; r < c + rowLength; r++) {
      int index = c * (rowLength - 1) + r;
      if (index <= _list.length - 1) children.add(index);
    }
    map[c] = children;
  }

  map.removeWhere((key, value) => value.isEmpty);
  return map;
}

enum SpColorPickerLevel {
  one,
  two,
}

class SpColorPicker extends StatefulWidget {
  const SpColorPicker({
    Key? key,
    required this.onPickedColor,
    this.currentColor,
    required this.blackWhite,
    this.level = SpColorPickerLevel.one,
  }) : super(key: key);

  final SpColorPickerLevel level;
  final ValueChanged<Color> onPickedColor;
  final Color? currentColor;
  final ColorSwatch blackWhite;

  static ColorSwatch<dynamic> getBlackWhite(BuildContext context) {
    bool isDarkMode = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final ColorSwatch blackWhiteColor = ColorSwatch(
      isDarkMode ? 0xFFFFFFFF : 0xFF000000,
      {50: Color(0xff000000), 100: Color(0xffffffff)},
    );
    return blackWhiteColor;
  }

  @override
  _SpColorPickerState createState() => _SpColorPickerState();
}

/// value 2 at end is border width `all(1)`
const double onPickingSwatchHeight = 34 * 4 + ConfigConstant.margin2 * 2 + ConfigConstant.margin1 * 4 + 2;
const double onPickingColorHeight = 34 * 2 + ConfigConstant.margin2 * 2 + ConfigConstant.margin1 * 2 - 4 + 2;

class _SpColorPickerState extends State<SpColorPicker> {
  Color? currentSelectedColor;
  Color? currentSelectedColorsSwatch;

  Map<int, List<int>>? _colorsMap;
  bool isColorChildPicking = false;

  final List<ColorSwatch> _colorsSwatch = [];
  List<Color?> _colorNormal = [];

  @override
  void initState() {
    super.initState();
    _colorsSwatch.addAll(materialColors);
    _colorsSwatch.add(widget.blackWhite);
    _colorsMap = listToTreeMap(_colorsSwatch);
    _setCurrentColor();
  }

  void _setCurrentColor() {
    Future.delayed(Duration(milliseconds: 1)).then((value) {
      for (ColorSwatch e in _colorsSwatch) {
        final _colorSwatches = _getMaterialColorShades(e);
        if (_colorSwatches.contains(widget.currentColor)) {
          setState(() {
            currentSelectedColorsSwatch = e;
          });
        }
      }
    });
  }

  List<Color?> _getMaterialColorShades(ColorSwatch color) {
    return <Color?>[
      if (color[50] != null) color[50],
      if (color[100] != null) color[100],
      if (color[200] != null) color[200],
      if (color[300] != null) color[300],
      if (color[400] != null) color[400],
      if (color[500] != null) color[500],
      if (color[600] != null) color[600],
      if (color[700] != null) color[700],
      if (color[800] != null) color[800],
      if (color[900] != null) color[900],
    ];
  }

  void onPickedColor(Color color) {
    switch (widget.level) {
      case SpColorPickerLevel.one:
        if (color == widget.blackWhite) {
          extendChildren(color);
        } else {
          widget.onPickedColor(color);
        }
        break;
      case SpColorPickerLevel.two:
        if (isColorChildPicking == false) {
          extendChildren(color);
        } else {
          widget.onPickedColor(color);
        }
        break;
    }
  }

  void extendChildren(color) {
    setState(() {
      isColorChildPicking = true;
      _colorNormal = _getMaterialColorShades(color!);
      _colorsMap = listToTreeMap(_colorNormal);
    });
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      if (widget.currentColor != null && _colorNormal.contains(widget.currentColor)) {
        setState(() {
          currentSelectedColor = widget.currentColor;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: onPickingSwatchHeight,
      alignment: Alignment.topRight,
      child: SpCrossFade(
        alignment: Alignment.topRight,
        showFirst: !isColorChildPicking,
        firstChild: buildColorListWrapper(
          context: context,
          child: buildColorListing(context),
          height: onPickingSwatchHeight,
        ),
        secondChild: buildColorListWrapper(
          context: context,
          height: _colorsMap!.length == 1 ? onPickingColorHeight - 32 - 12 : onPickingColorHeight,
          child: buildColorListing(context),
        ),
      ),
    );
  }

  Widget buildColorListWrapper({
    required BuildContext context,
    required Widget child,
    required double height,
  }) {
    return Container(
      padding: const EdgeInsets.all(ConfigConstant.margin2).copyWith(bottom: ConfigConstant.margin2 - 8),
      height: height,
      decoration: BoxDecoration(
        color: M3Color.of(context).background,
        borderRadius: ConfigConstant.circlarRadius2,
        border: Border.all(color: M3Color.of(context).onBackground.withOpacity(0.1), width: 1),
      ),
      child: child,
    );
  }

  Widget buildColorListing(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        _colorsMap!.length,
        (c) {
          final List<int>? childrenIndex = _colorsMap![c];
          final double bottom = _colorsMap!.length - 1 == c ? 0 : ConfigConstant.margin1;
          return Container(
            margin: EdgeInsets.only(bottom: bottom),
            child: Row(
              children: List.generate(
                _colorsMap![c]!.length,
                (i) => buildColorItem(childrenIndex, i, context),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildColorItem(List<int>? childrenIndex, int i, BuildContext context) {
    final int index = childrenIndex![i];
    final double right = i != (childrenIndex.length) - 1 ? ConfigConstant.margin1 : 0;
    final dynamic color;
    color = isColorChildPicking ? _colorNormal[index] : _colorsSwatch[index];
    final bool isSelected = currentSelectedColor == color || currentSelectedColorsSwatch == color;
    return SpColorItem(
      color: color,
      selected: isSelected,
      margin: EdgeInsets.only(right: right, bottom: 0, top: 0),
      onPressed: (color) => onPickedColor(color),
    );
  }
}

class SpColorItem extends StatelessWidget {
  const SpColorItem({
    Key? key,
    this.margin,
    this.selected = false,
    this.onPressed,
    required this.color,
    this.size = ConfigConstant.iconSize3,
  }) : super(key: key);

  final EdgeInsets? margin;
  final bool selected;
  final Color color;
  final void Function(Color)? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: ConfigConstant.fadeDuration,
      margin: margin,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 2.0,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(selected ? 1 : 0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: SpTapEffect(
          effects: [
            // SpTapEffectType.touchableOpacity,
            SpTapEffectType.border,
          ],
          onTap: onPressed != null ? () => onPressed!(color) : null,
          child: Container(
            width: size - 2,
            height: size - 2,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
