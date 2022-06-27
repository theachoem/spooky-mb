// ignore_for_file: implementation_imports

import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/db/databases/tag_database.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/db/models/tag_db_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/providers/story_list_configuration_provider.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/quill_helper.dart';
import 'package:spooky/views/home/local_widgets/add_to_drive_button.dart';
import 'package:flutter_quill/src/widgets/embeds/image.dart';
import 'package:spooky/widgets/sp_chip.dart';

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
    final tags = story.tags ?? [];
    final fileImages = fetchFileImages();
    return [
      if (content.draft == true)
        const SpChip(
          labelText: "Draft",
          avatar: Icon(CommunityMaterialIcons.pen, size: ConfigConstant.iconSize1),
        ),
      if (tags.isNotEmpty)
        SpChip(
          labelText: tags.length.toString(),
          avatar: const Icon(CommunityMaterialIcons.tag, size: ConfigConstant.iconSize1),
          onTap: () async {
            BaseDbListModel<TagDbModel>? items = await TagDatabase.instance.fetchAll();
            List<TagDbModel> dbTags = items?.items ?? [];

            dbTags = dbTags.where((e) {
              return tags.contains(e.id.toString());
            }).toList();

            int? id = await showConfirmationDialog(
              context: context,
              title: 'Tags',
              actions: dbTags.map((e) {
                return AlertDialogAction(key: e.id, label: e.title);
              }).toList(),
            );

            if (id == null) return;
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushNamed(
              SpRouter.search.path,
              arguments: SearchArgs(
                displayTag: dbTags.where((e) => e.id == id).first.title,
                initialQuery: StoryQueryOptionsModel(
                  type: PathType.docs,
                  tag: id.toString(),
                ),
              ),
            );
          },
        ),
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
      imageProvider = QuillHelper.imageByUrl(imageUrl);
      if (imageProvider != null) break;
    }

    return SpChip(
      labelText: "${images.length} Images",
      avatar: imageProvider != null ? CircleAvatar(backgroundImage: imageProvider) : null,
    );
  }
}
