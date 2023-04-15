import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:spooky/core/story_writers/auto_save_story_writer.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

class SpImageButton extends StatelessWidget {
  const SpImageButton({
    required this.icon,
    required this.controller,
    this.iconSize = kDefaultIconSize,
    this.fillColor,
    this.iconTheme,
    this.dialogTheme,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final double iconSize;
  final Color? fillColor;
  final QuillController controller;
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
      cancelLabel: tr("button.cancel"),
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
    AutoSaveStoryWriter.instance.skipNotification();

    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      String? image = await _onPickedImage(context, File(pickedFile.path));
      if (image == null) return;

      _linkSubmitted(image);
    }

    AutoSaveStoryWriter.instance.allowNotification();
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

      File localFile = File(FileHelper.addDirectory("images/${basename(file.path)}"));

      await localFile.create(recursive: true);
      await localFile.writeAsBytes(await croppedFile.readAsBytes());

      return localFile.path;
    }

    return null;
  }

  void _typeLink(BuildContext context) async {
    List<String>? result = await showTextInputDialog(
      context: context,
      title: tr("alert.add_image_url.title"),
      okLabel: tr("button.ok"),
      cancelLabel: tr("button.cancel"),
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

      // DRIVE file
      // IN: https://drive.google.com/file/d/1WKDgvlrOkmkjFZ35otkQpR_4sCOwcntl/view?usp=sharing
      // OUT: https://drive.google.com/uc?export=download&id=1WKDgvlrOkmkjFZ35otkQpR_4sCOwcntl
      if (imageUrl.contains('drive.google.com/file/d')) {
        Uri? imageUri = Uri.tryParse(imageUrl);
        if (imageUri == null) return;

        List<String> pathSegments = [...imageUri.pathSegments];
        pathSegments.remove("file");
        pathSegments.remove("d");
        pathSegments.remove("view");

        Iterable<String> founds = pathSegments.where((element) => element.length > 25);
        if (founds.isNotEmpty) {
          String driveId = founds.first;
          imageUrl = "https://drive.google.com/uc?export=download&id=$driveId";
        }
      }

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
