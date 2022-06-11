import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:spooky/core/services/messenger_service.dart';

class SpImageButton extends StatelessWidget {
  const SpImageButton({
    required this.icon,
    required this.controller,
    this.iconSize = kDefaultIconSize,
    required this.onImagePickCallback,
    this.fillColor,
    this.filePickImpl,
    this.webImagePickImpl,
    this.mediaPickSettingSelector,
    this.iconTheme,
    this.dialogTheme,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final double iconSize;
  final Color? fillColor;
  final QuillController controller;
  final OnImagePickCallback onImagePickCallback;
  final WebImagePickImpl? webImagePickImpl;
  final FilePickImpl? filePickImpl;
  final MediaPickSettingSelector? mediaPickSettingSelector;
  final QuillIconTheme? iconTheme;
  final QuillDialogTheme? dialogTheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final iconColor = iconTheme?.iconUnselectedColor ?? theme.iconTheme.color;
    final iconFillColor = iconTheme?.iconUnselectedFillColor ?? (fillColor ?? theme.canvasColor);

    return QuillIconButton(
      icon: Icon(icon, size: iconSize, color: iconColor),
      highlightElevation: 0,
      hoverElevation: 0,
      size: iconSize * 1.77,
      fillColor: iconFillColor,
      onPressed: () => _onPressedHandler(context),
    );
  }

  Future<void> _onPressedHandler(BuildContext context) async {
    await showModalActionSheet(
      context: context,
      actions: const [
        SheetAction(label: "Gallery", key: "gallery"),
        SheetAction(label: "Camera", key: "camera"),
        SheetAction(label: "Link", key: "link"),
      ],
    ).then((selectedOption) {
      switch (selectedOption) {
        case "gallery":
          _pickImage(context, ImageSource.gallery);
          break;
        case "camera":
          _pickImage(context, ImageSource.camera);
          break;
        case "link":
          _typeLink(context);
          break;
      }
    });
  }

  void _pickImage(BuildContext context, ImageSource source) async {
    ImageVideoUtils.handleImageButtonTap(
      context,
      controller,
      source,
      onImagePickCallback,
      filePickImpl: filePickImpl,
      webImagePickImpl: webImagePickImpl,
    );
  }

  void _typeLink(BuildContext context) async {
    List<String>? result = await showTextInputDialog(
      context: context,
      title: "Add an image",
      textFields: [
        DialogTextField(
          initialText: "",
          hintText: "Image url",
          validator: (String? value) {
            if (value?.trim().isNotEmpty == true) return null;
            return "Invalid";
          },
        ),
      ],
    );
    if (result?.isNotEmpty == true) {
      String imageUrl = result!.first;
      Uri? uri = Uri.tryParse(imageUrl);
      http.Response? response;

      try {
        response = uri != null ? await http.head(uri) : null;
      } catch (e) {
        if (kDebugMode) print("ERROR: _typeLink: $e");
      }

      if (response?.statusCode == 200) {
        _linkSubmitted(imageUrl);
      } else {
        MessengerService.instance.showSnackBar("Invalid image url", success: false);
      }
    }
  }

  void _linkSubmitted(String? value) {
    if (value != null && value.isNotEmpty) {
      final index = controller.selection.baseOffset;
      final length = controller.selection.extentOffset - index;
      controller.replaceText(index, length, BlockEmbed.image(value), null);
    }
  }
}
