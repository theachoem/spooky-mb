import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:image_cropper/image_cropper.dart';

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
      actions: [
        SheetAction(label: tr("button.image_via_gallery"), key: "gallery"),
        SheetAction(label: tr("button.image_via_camera"), key: "camera"),
        SheetAction(label: tr("button.image_via_link"), key: "link"),
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
      (file) => _onPickedImage(context, file),
      filePickImpl: filePickImpl,
      webImagePickImpl: webImagePickImpl,
    );
  }

  Future<String?> _onPickedImage(BuildContext context, File file) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatioPresets: CropAspectRatioPreset.values,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: tr("tile.crop_image"),
          toolbarColor: Theme.of(context).appBarTheme.backgroundColor,
          toolbarWidgetColor: Theme.of(context).appBarTheme.titleTextStyle?.color,
          backgroundColor: Theme.of(context).colorScheme.background,
          initAspectRatio: CropAspectRatioPreset.original,
        ),
        IOSUiSettings(
          title: tr("tile.crop_image"),
        ),
      ],
    );

    if (croppedFile != null) {
      await file.delete();
      await file.create(recursive: true);
      await file.writeAsBytes(await croppedFile.readAsBytes());
      return file.path;
    }

    return null;
  }

  void _typeLink(BuildContext context) async {
    List<String>? result = await showTextInputDialog(
      context: context,
      title: tr("alert.add_image_url.title"),
      textFields: [
        DialogTextField(
          initialText: "",
          hintText: tr("field.image_url.hint_text"),
          validator: (String? value) {
            if (value?.trim().isNotEmpty == true) return null;
            return tr("field.image_url.validation");
          },
        ),
      ],
    );
    if (result?.isNotEmpty == true) {
      String imageUrl = result!.first;
      File? file;

      try {
        file = await DefaultCacheManager().getSingleFile(imageUrl);
      } catch (e) {
        if (kDebugMode) print("ERROR: _typeLink: $e");
      }

      if (file != null) {
        _linkSubmitted(imageUrl);
      } else {
        MessengerService.instance.showSnackBar(tr("field.image_url.validation"), success: false);
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
