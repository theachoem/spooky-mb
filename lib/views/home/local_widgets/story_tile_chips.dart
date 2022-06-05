// ignore_for_file: implementation_imports

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/src/widgets/embeds/image.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/providers/story_list_configuration_provider.dart';
import 'package:spooky/views/home/local_widgets/add_to_drive_button.dart';
import 'package:spooky/widgets/sp_chip.dart';
import 'dart:convert';

class StoryTileChips extends StatelessWidget {
  const StoryTileChips({
    Key? key,
    required this.images,
    required this.content,
    required this.story,
    required this.onImageUploaded,
  }) : super(key: key);

  final Set<String> images;
  final StoryContentDbModel content;
  final StoryDbModel story;
  final void Function(StoryContentDbModel) onImageUploaded;

  @override
  Widget build(BuildContext context) {
    StoryListConfigurationProvider provider = Provider.of<StoryListConfigurationProvider>(context, listen: true);
    if (!provider.shouldShowChip) return const SizedBox.shrink();
    return Wrap(
      children: getChipList(images, content, story, context).map(
        (child) {
          return Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: child,
          );
        },
      ).toList(),
    );
  }

  List<Widget> getChipList(
    Set<String> images,
    StoryContentDbModel content,
    StoryDbModel story,
    BuildContext context,
  ) {
    final fileImages = fetchFileImages();
    return [
      if ((content.pages?.length ?? 0) > 1) SpChip(labelText: "${content.pages?.length} Pages"),
      if (images.isNotEmpty) buildImageChip(images),
      AddToDriveButton(
        content: content,
        story: story,
        fileImages: fileImages,
        onUploaded: onImageUploaded,
      ),
      // SpDeveloperVisibility(
      //   child: SpChip(
      //     avatar: Icon(Icons.developer_board, size: ConfigConstant.iconSize1),
      //     labelText: FileHelper.fileName(story.file!.path),
      //   ),
      // ),
    ];
  }

  List<String> fetchFileImages() {
    List<String> fileImages = [];
    for (String src in images) {
      final file = File(src);
      if (file.existsSync()) fileImages.add(src);
    }
    return fileImages;
  }

  SpChip buildImageChip(Set<String> images) {
    ImageProvider? imageProvider;

    // loop to get validated one
    for (String src in images) {
      String imageUrl = standardizeImageUrl(src);
      imageProvider = imageByUrl(imageUrl);
      if (imageProvider != null) break;
    }

    return SpChip(
      labelText: "${images.length} Images",
      avatar: imageProvider != null ? CircleAvatar(backgroundImage: imageProvider) : null,
    );
  }

  ImageProvider? imageByUrl(String imageUrl) {
    if (isImageBase64(imageUrl)) return MemoryImage(base64.decode(imageUrl));
    if (imageUrl.startsWith('http')) return CachedNetworkImageProvider(imageUrl);
    if (File(imageUrl).existsSync()) return FileImage(File(imageUrl));
    return null;
  }
}
