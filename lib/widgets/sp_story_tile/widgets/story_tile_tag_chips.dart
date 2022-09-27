import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
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

class StoryTileTagChips extends StatefulWidget {
  const StoryTileTagChips({
    Key? key,
    required this.tags,
    this.showZero = false,
    this.keepAlive = false,
  }) : super(key: key);

  final List<String> tags;
  final bool showZero;
  final bool keepAlive;

  @override
  State<StoryTileTagChips> createState() => _StoryTileTagChipsState();
}

class _StoryTileTagChipsState extends State<StoryTileTagChips> with AutomaticKeepAliveClientMixin {
  BaseDbListModel<TagDbModel>? items;
  List<TagDbModel> dbTags = [];

  @override
  void initState() {
    super.initState();
    TagDatabase.instance.fetchAllCache().then((value) {
      setState(() {
        items = value;
        setDbTags();
      });
    });
  }

  void setDbTags() {
    dbTags = items?.items ?? [];
    dbTags = dbTags.where((e) {
      return widget.tags.contains(e.id.toString());
    }).toList();
  }

  @override
  void didUpdateWidget(covariant StoryTileTagChips oldWidget) {
    setDbTags();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!widget.showZero) {
      return SpCrossFade(
        showFirst: items == null,
        alignment: Alignment.center,
        firstChild: buildChip(dbTags, context),
        secondChild: buildChip(dbTags, context),
      );
    } else {
      return buildChip(dbTags, context);
    }
  }

  Widget buildChip(List<TagDbModel> dbTags, BuildContext context) {
    return SpChip(
      labelText: dbTags.length == 1 ? dbTags.first.title : widget.tags.length.toString(),
      avatar: const Icon(CommunityMaterialIcons.tag, size: ConfigConstant.iconSize1),
      onTap: () async {
        int? id;
        if (dbTags.length == 1) {
          id = dbTags.first.id;
        } else {
          id = await showModalActionSheet(
            context: context,
            title: tr("section.tags"),
            cancelLabel: tr("button.cancel"),
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

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
