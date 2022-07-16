// ignore_for_file: implementation_imports

import 'dart:io';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/providers/story_list_configuration_provider.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/utils/helpers/quill_helper.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_story_tile/widgets/add_to_drive_button.dart';
import 'package:flutter_quill/src/widgets/embeds/image.dart';
import 'package:spooky/widgets/sp_story_tile/widgets/story_tile_tag_chips.dart';
import 'package:spooky/widgets/sp_chip.dart';

enum ChipsExpandLevelType {
  level1,
  level2,
  level3,
}

class StoryTileChips extends StatelessWidget {
  StoryTileChips({
    Key? key,
    required this.content,
    required this.story,
    required this.onImageUploaded,
    this.expandedLevel,
    this.showDate = false,
    this.showZeroInTags = false,
  }) : super(key: key) {
    images = {};
    content.pages?.forEach((page) {
      images.addAll(QuillHelper.imagesFromJson(page));
    });
  }

  late final Set<String> images;
  final void Function(StoryContentDbModel) onImageUploaded;
  final ChipsExpandLevelType? expandedLevel;
  final StoryContentDbModel content;
  final StoryDbModel story;
  final bool showDate;
  final bool showZeroInTags;

  bool get level1 => expandedLevel == ChipsExpandLevelType.level1;
  bool get level2 => expandedLevel == ChipsExpandLevelType.level2;
  bool get level3 => expandedLevel == ChipsExpandLevelType.level3;

  @override
  Widget build(BuildContext context) {
    StoryListConfigurationProvider provider = Provider.of<StoryListConfigurationProvider>(context, listen: true);

    if (!provider.shouldShowChip) return const SizedBox.shrink();
    List<Widget> chips = getChipList(images, content, story, context);
    if (chips.isEmpty) return const SizedBox.shrink();

    return SpCrossFade(
      showFirst: level1,
      alignment: Alignment.topLeft,
      firstChild: const SizedBox(width: double.infinity),
      secondChild: Wrap(
        children: chips.map(
          (child) {
            return Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: child,
            );
          },
        ).toList(),
      ),
    );
  }

  List<Widget> getChipList(
    Set<String> images,
    StoryContentDbModel content,
    StoryDbModel story,
    BuildContext context,
  ) {
    final tags = story.tags ?? [];
    final fileImages = fetchFileImages();

    List<Widget> level3Widgets = [
      if ((content.pages?.length ?? 0) > 1) SpChip(labelText: "${content.pages?.length} Pages"),
      if (showDate)
        SpChip(
          avatar: const Icon(CommunityMaterialIcons.clock, size: ConfigConstant.iconSize1),
          labelText: DateFormatHelper.timeFormat().format(story.displayPathDate),
        ),
      if (showDate)
        SpChip(
          avatar: const Icon(CommunityMaterialIcons.calendar, size: ConfigConstant.iconSize1),
          labelText: DateFormatHelper.dateFormat().format(story.displayPathDate),
        ),
    ];

    return [
      if (expandedLevel == null)
        ...level3Widgets
      else if (level3Widgets.isNotEmpty)
        SpCrossFade(
          alignment: Alignment.topLeft,
          showFirst: level3,
          secondChild: const SizedBox(width: double.infinity),
          firstChild: level3Widgets.length == 1
              ? level3Widgets[0]
              : Wrap(children: [
                  ...level3Widgets.take(level3Widgets.length - 1).map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: e,
                    );
                  }).toList(),
                  level3Widgets.last,
                ]),
        ),

      if (tags.isNotEmpty || showZeroInTags) StoryTileTagChips(tags: tags, showZero: showZeroInTags),
      if (images.isNotEmpty) buildImageChip(images),
      SpCrossFade(
        alignment: Alignment.topLeft,
        showFirst: fileImages.isEmpty,
        firstChild: const SizedBox(width: double.infinity),
        secondChild: AddToDriveButton(
          content: content,
          story: story,
          fileImages: fileImages,
          onUploaded: onImageUploaded,
        ),
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
      imageProvider = QuillHelper.imageByUrl(imageUrl);
      if (imageProvider != null) break;
    }

    return SpChip(
      labelText: images.length > 1 ? "${images.length} Images" : "${images.length} Image",
      avatar: imageProvider != null ? CircleAvatar(backgroundImage: imageProvider) : null,
    );
  }
}
