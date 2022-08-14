// ignore_for_file: implementation_imports

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/src/widgets/link.dart';
import 'package:flutter_quill/src/models/rules/insert.dart';
import 'package:tuple/tuple.dart';

/// [LinkStyleButton]
class SpLinkStyleButton extends StatefulWidget {
  const SpLinkStyleButton({
    required this.controller,
    this.iconSize = kDefaultIconSize,
    this.icon,
    this.iconTheme,
    this.dialogTheme,
    Key? key,
  }) : super(key: key);

  final QuillController controller;
  final IconData? icon;
  final double iconSize;
  final QuillIconTheme? iconTheme;
  final QuillDialogTheme? dialogTheme;

  @override
  SpLinkStyleButtonState createState() => SpLinkStyleButtonState();
}

class SpLinkStyleButtonState extends State<SpLinkStyleButton> {
  void _didChangeSelection() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeSelection);
  }

  @override
  void didUpdateWidget(covariant SpLinkStyleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeSelection);
      widget.controller.addListener(_didChangeSelection);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_didChangeSelection);
  }

  final GlobalKey _toolTipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isToggled = _getLinkAttributeValue() != null;
    return GestureDetector(
      onTap: () async {
        final dynamic tooltip = _toolTipKey.currentState;
        tooltip.ensureTooltipVisible();
        Future.delayed(
          const Duration(
            seconds: 3,
          ),
          tooltip.deactivate,
        );
      },
      child: Tooltip(
        key: _toolTipKey,
        message: "",
        child: QuillIconButton(
          highlightElevation: 0,
          hoverElevation: 0,
          size: widget.iconSize * kIconButtonFactor,
          icon: Icon(
            widget.icon ?? Icons.link,
            size: widget.iconSize,
            color: isToggled
                ? (widget.iconTheme?.iconUnselectedColor ?? theme.iconTheme.color)
                : (widget.iconTheme?.disabledIconColor ?? theme.disabledColor),
          ),
          fillColor: widget.iconTheme?.iconUnselectedFillColor ?? theme.canvasColor,
          onPressed: () async {
            final link = _getLinkAttributeValue();
            final index = widget.controller.selection.start;
            String? text;

            if (link != null) {
              // text should be the link's corresponding text, not selection
              final leaf = widget.controller.document.querySegmentLeafNode(index).item2;
              if (leaf != null) {
                text = leaf.toPlainText();
              }
            }

            final len = widget.controller.selection.end - index;
            text ??= len == 0 ? '' : widget.controller.document.getPlainText(index, len);

            List<String>? values = await showTextInputDialog(
              title: link != null ? tr("alert.link.edit.title") : tr("alert.link.add.title"),
              context: context,
              textFields: [
                DialogTextField(
                  initialText: text,
                  hintText: tr("field.text.hint_text"),
                  validator: (String? text) {
                    if (text?.trim().isNotEmpty == true) {
                      return null;
                    } else {
                      return tr("field.text.validation");
                    }
                  },
                ),
                DialogTextField(
                  initialText: link,
                  hintText: tr("field.link.hint_text"),
                  validator: (String? link) {
                    if (link != null && AutoFormatMultipleLinksRule.linkRegExp.hasMatch(link)) {
                      return null;
                    } else {
                      return tr("field.link.validation");
                    }
                  },
                ),
              ],
            );

            if (values != null && values.length >= 2) {
              String text = values[0];
              String link = values[0];
              _linkSubmitted(Tuple2(text, link));
            }
          },
        ),
      ),
    );
  }

  String? _getLinkAttributeValue() {
    return widget.controller.getSelectionStyle().attributes[Attribute.link.key]?.value;
  }

  void _linkSubmitted(dynamic value) {
    // text.isNotEmpty && link.isNotEmpty
    final String text = (value as Tuple2).item1;
    final String link = value.item2.trim();

    var index = widget.controller.selection.start;
    var length = widget.controller.selection.end - index;
    if (_getLinkAttributeValue() != null) {
      // text should be the link's corresponding text, not selection
      final leaf = widget.controller.document.querySegmentLeafNode(index).item2;
      if (leaf != null) {
        final range = getLinkRange(leaf);
        index = range.start;
        length = range.end - range.start;
      }
    }
    widget.controller.replaceText(index, length, text, null);
    widget.controller.formatText(index, text.length, LinkAttribute(link));
  }
}
