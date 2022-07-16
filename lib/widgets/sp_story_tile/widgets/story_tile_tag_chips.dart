import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/db/databases/tag_database.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/models/tag_db_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_chip.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';

class StoryTileTagChips extends StatelessWidget {
  const StoryTileTagChips({
    Key? key,
    required this.tags,
    this.showZero = false,
  }) : super(key: key);

  final List<String> tags;
  final bool showZero;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BaseDbListModel<TagDbModel>?>(
      future: TagDatabase.instance.fetchAll(),
      builder: (context, snapshot) {
        BaseDbListModel<TagDbModel>? items = snapshot.data;
        List<TagDbModel> dbTags = items?.items ?? [];

        dbTags = dbTags.where((e) {
          return tags.contains(e.id.toString());
        }).toList();

        if (!showZero) {
          return SpCrossFade(
            showFirst: items == null,
            alignment: Alignment.center,
            firstChild: buildChip(dbTags, context),
            secondChild: buildChip(dbTags, context),
          );
        } else {
          return buildChip(dbTags, context);
        }
      },
    );
  }

  Widget buildChip(List<TagDbModel> dbTags, BuildContext context) {
    return SpChip(
      labelText: dbTags.length == 1 ? dbTags.first.title : tags.length.toString(),
      avatar: const Icon(CommunityMaterialIcons.tag, size: ConfigConstant.iconSize1),
      onTap: () async {
        int? id;
        if (dbTags.length == 1) {
          id = dbTags.first.id;
        } else {
          id = await showModalActionSheet(
            context: context,
            title: 'Tags',
            actions: dbTags.map((e) {
              return SheetAction(
                key: e.id,
                label: e.title,
                icon: CommunityMaterialIcons.tag,
              );
            }).toList(),
          );
        }

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
    );
  }
}
