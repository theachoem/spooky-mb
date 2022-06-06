import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/api/cloud_storages/gdrive_spooky_folder_storage.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_chip.dart';

class AddToDriveButton extends StatefulWidget {
  const AddToDriveButton({
    Key? key,
    required this.story,
    required this.content,
    required this.fileImages,
    required this.onUploaded,
  }) : super(key: key);

  final StoryDbModel story;
  final StoryContentDbModel content;
  final List<String> fileImages;
  final void Function(StoryContentDbModel) onUploaded;

  @override
  State<AddToDriveButton> createState() => _AddToDriveButtonState();
}

class _AddToDriveButtonState extends State<AddToDriveButton> {
  late ValueNotifier<bool> visibleNotifier;
  bool uploading = false;

  Future<String?> uploadToDrive(String src) async {
    return GDriveSpookyFolderStorage().uploadImage(File(src));
  }

  Future<void> upload() async {
    if (uploading) return;
    setState(() {
      uploading = true;
    });

    if (widget.fileImages.isNotEmpty) {
      String encode = jsonEncode(widget.content);
      for (String src in widget.fileImages) {
        String? imageDriveUrl;

        try {
          imageDriveUrl = await uploadToDrive(src);
        } catch (e) {
          if (kDebugMode) rethrow;
        }

        if (imageDriveUrl != null) {
          encode = encode.replaceAll(src, imageDriveUrl);
        }
      }
      final content = StoryContentDbModel.fromJson(jsonDecode(encode));
      widget.onUploaded(content);
    }

    setState(() {
      uploading = false;
    });
  }

  @override
  void initState() {
    visibleNotifier = ValueNotifier(fetchVisible());
    super.initState();
  }

  bool fetchVisible() {
    return widget.fileImages.isNotEmpty;
  }

  @override
  void dispose() {
    visibleNotifier.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AddToDriveButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool empty = widget.fileImages.isEmpty;
    if (widget.fileImages.isEmpty && visibleNotifier.value != empty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Future.delayed(ConfigConstant.duration).then((value) {
          visibleNotifier.value = fetchVisible();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: visibleNotifier,
      child: AnimatedOpacity(
        opacity: widget.fileImages.isEmpty ? 0 : 1,
        duration: ConfigConstant.duration,
        child: SpChip(
          labelText: "Upload",
          onTap: () => upload(),
          avatar: SpAnimatedIcons(
            showFirst: uploading,
            firstChild: const CircularProgressIndicator.adaptive(),
            secondChild: Icon(
              Icons.add_to_drive,
              size: ConfigConstant.iconSize1,
              color: M3Color.of(context).onBackground,
            ),
          ),
        ),
      ),
      builder: (context, visible, child) {
        return Visibility(
          visible: visible,
          child: child!,
        );
      },
    );
  }
}
