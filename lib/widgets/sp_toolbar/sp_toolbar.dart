import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';
import 'package:spooky/widgets/sp_toolbar/sp_color_button.dart';
import 'package:spooky/widgets/sp_toolbar/sp_link_style_button.dart';

/// [QuillToolbar]
class SpToolbar extends StatefulWidget {
  const SpToolbar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final QuillController controller;

  static _SpToolbarState? of(BuildContext context) {
    return context.findAncestorStateOfType<_SpToolbarState>();
  }

  @override
  State<SpToolbar> createState() => _SpToolbarState();
}

class _SpToolbarState extends State<SpToolbar> with StatefulMixin {
  QuillIconTheme get iconTheme {
    return QuillIconTheme(
      iconSelectedColor: colorScheme.onSecondaryContainer,
      iconUnselectedColor: colorScheme.onSurfaceVariant,
      iconSelectedFillColor: colorScheme.secondaryContainer,
      iconUnselectedFillColor: Colors.transparent,
      disabledIconColor: themeData.disabledColor,
      disabledIconFillColor: Colors.transparent,
    );
  }

  double get toolbarIconSize => 24;
  QuillController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tightFor(height: kToolbarHeight),
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin1),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            HistoryButton(
              icon: Icons.undo_outlined,
              iconSize: toolbarIconSize,
              controller: controller,
              undo: true,
              iconTheme: iconTheme,
            ),
            HistoryButton(
              icon: Icons.redo_outlined,
              iconSize: toolbarIconSize,
              controller: controller,
              undo: false,
              iconTheme: iconTheme,
            ),
            ToggleStyleButton(
              attribute: Attribute.bold,
              icon: Icons.format_bold,
              iconSize: toolbarIconSize,
              controller: controller,
              iconTheme: iconTheme,
            ),
            ToggleStyleButton(
              attribute: Attribute.italic,
              icon: Icons.format_italic,
              iconSize: toolbarIconSize,
              controller: controller,
              iconTheme: iconTheme,
            ),
            ToggleStyleButton(
              attribute: Attribute.small,
              icon: Icons.format_size,
              iconSize: toolbarIconSize,
              controller: controller,
              iconTheme: iconTheme,
            ),
            ToggleStyleButton(
              attribute: Attribute.underline,
              icon: Icons.format_underline,
              iconSize: toolbarIconSize,
              controller: controller,
              iconTheme: iconTheme,
            ),
            ToggleStyleButton(
              attribute: Attribute.strikeThrough,
              icon: Icons.format_strikethrough,
              iconSize: toolbarIconSize,
              controller: controller,
              iconTheme: iconTheme,
            ),
            ToggleStyleButton(
              attribute: Attribute.inlineCode,
              icon: Icons.code,
              iconSize: toolbarIconSize,
              controller: controller,
              iconTheme: iconTheme,
            ),
            SpColorButton(
              icon: Icons.color_lens,
              iconSize: toolbarIconSize,
              controller: controller,
              background: false,
              iconTheme: iconTheme,
            ),
            SpColorButton(
              icon: Icons.format_color_fill,
              iconSize: toolbarIconSize,
              controller: controller,
              background: true,
              iconTheme: iconTheme,
            ),
            ClearFormatButton(
              icon: Icons.format_clear,
              iconSize: toolbarIconSize,
              controller: controller,
              iconTheme: iconTheme,
            ),
            // ImageButton(
            //   icon: Icons.image,
            //   iconSize: toolbarIconSize,
            //   controller: controller,
            //   onImagePickCallback: (){},
            //   filePickImpl: filePickImpl,
            //   webImagePickImpl: webImagePickImpl,
            //   mediaPickSettingSelector: mediaPickSettingSelector,
            //   iconTheme: iconTheme,
            //   dialogTheme: dialogTheme,
            // ),
            // VideoButton(
            //   icon: Icons.movie_creation,
            //   iconSize: toolbarIconSize,
            //   controller: controller,
            //   onVideoPickCallback: onVideoPickCallback,
            //   filePickImpl: filePickImpl,
            //   webVideoPickImpl: webImagePickImpl,
            //   mediaPickSettingSelector: mediaPickSettingSelector,
            //   iconTheme: iconTheme,
            //   dialogTheme: dialogTheme,
            // ),
            // CameraButton(
            //   icon: Icons.photo_camera,
            //   iconSize: toolbarIconSize,
            //   controller: controller,
            //   onImagePickCallback: onImagePickCallback,
            //   onVideoPickCallback: onVideoPickCallback,
            //   filePickImpl: filePickImpl,
            //   webImagePickImpl: webImagePickImpl,
            //   webVideoPickImpl: webVideoPickImpl,
            //   iconTheme: iconTheme,
            // ),
            buildDivider(),
            SelectAlignmentButton(
              controller: controller,
              iconSize: toolbarIconSize,
              iconTheme: iconTheme,
              showLeftAlignment: true,
              showCenterAlignment: true,
              showRightAlignment: true,
              showJustifyAlignment: true,
            ),
            // ToggleStyleButton(
            //   attribute: Attribute.rtl,
            //   controller: controller,
            //   icon: Icons.format_textdirection_r_to_l,
            //   iconSize: toolbarIconSize,
            //   iconTheme: iconTheme,
            // ),
            buildDivider(),
            SelectHeaderStyleButton(
              controller: controller,
              iconSize: toolbarIconSize,
              iconTheme: iconTheme,
            ),
            buildDivider(),
            ToggleStyleButton(
              attribute: Attribute.ol,
              controller: controller,
              icon: Icons.format_list_numbered,
              iconSize: toolbarIconSize,
              iconTheme: iconTheme,
            ),
            ToggleStyleButton(
              attribute: Attribute.ul,
              controller: controller,
              icon: Icons.format_list_bulleted,
              iconSize: toolbarIconSize,
              iconTheme: iconTheme,
            ),
            ToggleCheckListButton(
              attribute: Attribute.unchecked,
              controller: controller,
              icon: Icons.check_box,
              iconSize: toolbarIconSize,
              iconTheme: iconTheme,
            ),
            ToggleStyleButton(
              attribute: Attribute.codeBlock,
              controller: controller,
              icon: Icons.code,
              iconSize: toolbarIconSize,
              iconTheme: iconTheme,
            ),
            buildDivider(),
            ToggleStyleButton(
              attribute: Attribute.blockQuote,
              controller: controller,
              icon: Icons.format_quote,
              iconSize: toolbarIconSize,
              iconTheme: iconTheme,
            ),
            IndentButton(
              icon: Icons.format_indent_increase,
              iconSize: toolbarIconSize,
              controller: controller,
              isIncrease: true,
              iconTheme: iconTheme,
            ),
            IndentButton(
              icon: Icons.format_indent_decrease,
              iconSize: toolbarIconSize,
              controller: controller,
              isIncrease: false,
              iconTheme: iconTheme,
            ),
            VerticalDivider(
              indent: 12,
              endIndent: 12,
              color: colorScheme.onSurface,
            ),
            SpLinkStyleButton(
              controller: controller,
              iconSize: toolbarIconSize,
              iconTheme: iconTheme,
              dialogTheme: null,
            ),
          ].map((e) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: !kIsWeb ? 1.0 : 5.0),
              child: e,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildDivider() {
    return VerticalDivider(
      indent: 12,
      endIndent: 12,
      color: colorScheme.onSurface.withOpacity(0.5),
    );
  }
}
