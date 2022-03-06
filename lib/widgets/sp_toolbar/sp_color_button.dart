// ignore_for_file: implementation_imports

import 'package:flutter_quill/src/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';
import 'package:spooky/widgets/sp_color_picker.dart';
import 'package:spooky/widgets/sp_floating_popup_button.dart';

class SpColorButton extends StatefulWidget {
  const SpColorButton({
    required this.icon,
    required this.controller,
    required this.background,
    this.iconSize = kDefaultIconSize,
    this.iconTheme,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final double iconSize;
  final bool background;
  final QuillController controller;
  final QuillIconTheme? iconTheme;

  @override
  _SpColorButtonState createState() => _SpColorButtonState();
}

class _SpColorButtonState extends State<SpColorButton> with StatefulMixin {
  late bool _isToggledColor;
  late bool _isToggledBackground;

  Style get _selectionStyle => widget.controller.getSelectionStyle();

  void _didChangeEditingValue() {
    setState(() {
      _isToggledColor = _getIsToggledColor(widget.controller.getSelectionStyle().attributes);
      _isToggledBackground = _getIsToggledBackground(widget.controller.getSelectionStyle().attributes);
    });
  }

  @override
  void initState() {
    super.initState();
    _isToggledColor = _getIsToggledColor(_selectionStyle.attributes);
    _isToggledBackground = _getIsToggledBackground(_selectionStyle.attributes);
    widget.controller.addListener(_didChangeEditingValue);
  }

  bool _getIsToggledColor(Map<String, Attribute> attrs) {
    return attrs.containsKey(Attribute.color.key);
  }

  bool _getIsToggledBackground(Map<String, Attribute> attrs) {
    return attrs.containsKey(Attribute.background.key);
  }

  @override
  void didUpdateWidget(covariant SpColorButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
      _isToggledColor = _getIsToggledColor(_selectionStyle.attributes);
      _isToggledBackground = _getIsToggledBackground(_selectionStyle.attributes);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  Color _textColorForBackground(Color backgroundColor) {
    if (ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark) {
      return Colors.white;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    Color? iconColor = _isToggledColor && !widget.background
        ? stringToColor(_selectionStyle.attributes['color']?.value)
        : themeData.iconTheme.color;

    Color? iconColorBackground = _isToggledBackground && widget.background
        ? stringToColor(_selectionStyle.attributes['background']?.value)
        : themeData.iconTheme.color;

    bool isDarkMode = themeData.colorScheme.brightness == Brightness.dark;
    Color? fillColor = _textColorForBackground(iconColor!);
    Color fillColorBackground = _textColorForBackground(iconColorBackground!);

    Color? displayIconColor;
    Color? displayiconColorBackground;

    if (fillColor == Colors.black) {
      if (isDarkMode) {
        fillColor = Colors.transparent;
        displayIconColor = iconColor;
      } else {
        fillColor = iconColor;
        displayIconColor = themeData.iconTheme.color;
      }
    } else if (fillColor == Colors.white) {
      if (isDarkMode) {
        fillColor = iconColor;
        displayIconColor = themeData.iconTheme.color;
      } else {
        fillColor = Colors.transparent;
        displayIconColor = iconColor;
      }
    }

    if (fillColorBackground == Colors.black) {
      if (isDarkMode) {
        fillColorBackground = Colors.transparent;
        displayiconColorBackground = iconColorBackground;
      } else {
        fillColorBackground = iconColorBackground;
        displayiconColorBackground = themeData.iconTheme.color;
      }
    } else if (fillColorBackground == Colors.white) {
      if (isDarkMode) {
        fillColorBackground = iconColorBackground;
        displayiconColorBackground = themeData.iconTheme.color;
      } else {
        fillColorBackground = Colors.transparent;
        displayiconColorBackground = iconColorBackground;
      }
    }

    return SpFloatingPopUpButton(
      cacheFloatingSize: spColorPickerMinWidth,
      dyGetter: (dy) => dy - (spOnPickingColorHeight * 2 - 8),
      floatBuilder: (callback) {
        return SpColorPicker(
          level: SpColorPickerLevel.two,
          blackWhite: SpColorPicker.getBlackWhite(context),
          currentColor: fillColorBackground,
          onPickedColor: (color) async {
            changeColor(color);
            callback();
          },
        );
      },
      builder: (callback) {
        return QuillIconButton(
          highlightElevation: 0,
          hoverElevation: 0,
          size: widget.iconSize * kIconButtonFactor,
          icon: Icon(
            widget.icon,
            size: widget.iconSize,
            color: widget.background ? displayiconColorBackground : displayIconColor,
          ),
          fillColor: widget.background ? fillColorBackground : fillColor,
          onPressed: callback,
        );
      },
    );
  }

  void changeColor(Color color) {
    String hex = color.value.toRadixString(16);
    if (hex.startsWith('ff')) hex = hex.substring(2);
    hex = '#$hex';
    widget.controller.formatSelection(widget.background ? BackgroundAttribute(hex) : ColorAttribute(hex));
  }
}
