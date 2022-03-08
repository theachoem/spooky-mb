// ignore_for_file: implementation_imports

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/src/widgets/embeds/image.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/providers/show_chips_provider.dart';
import 'package:spooky/widgets/sp_chip.dart';
import 'dart:convert';

class StoryTileChips extends StatelessWidget {
  const StoryTileChips({
    Key? key,
    required this.images,
    required this.content,
    required this.story,
  }) : super(key: key);

  final Set<String> images;
  final StoryContentModel content;
  final StoryModel story;

  @override
  Widget build(BuildContext context) {
    ShowChipsProvider provider = Provider.of<ShowChipsProvider>(context, listen: true);
    if (!provider.shouldShow) return const SizedBox.shrink();
    return Wrap(
      children: getChipList(images, content, story).map(
        (child) {
          return Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: child,
          );
        },
      ).toList(),
    );
  }

  List<Widget> getChipList(Set<String> images, StoryContentModel content, StoryModel story) {
    return [
      if (images.isNotEmpty) buildImageChip(images),
      if ((content.pages?.length ?? 0) > 1)
        SpChip(
          labelText: "${content.pages?.length} Pages",
        ),
      // SpDeveloperVisibility(
      //   child: SpChip(
      //     avatar: Icon(Icons.developer_board, size: ConfigConstant.iconSize1),
      //     labelText: FileHelper.fileName(story.file!.path),
      //   ),
      // ),
    ];
  }

  SpChip buildImageChip(Set<String> images) {
    String url = images.first;
    final imageUrl = standardizeImageUrl(url);
    return SpChip(
      labelText: "${images.length} Images",
      avatar: CircleAvatar(
        backgroundImage: imageByUrl(imageUrl),
      ),
    );
  }

  ImageProvider imageByUrl(String imageUrl) {
    if (isImageBase64(imageUrl)) return MemoryImage(base64.decode(imageUrl));
    if (imageUrl.startsWith('http')) return CachedNetworkImageProvider(imageUrl);
    return FileImage(File(imageUrl));
  }
}
