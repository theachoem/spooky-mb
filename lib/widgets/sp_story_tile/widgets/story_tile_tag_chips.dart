import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/db/models/tag_db_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/story_tags_service.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/theme/m3/m3_color.dart';
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
  List<TagDbModel>? dbTags;

  @override
  void initState() {
    super.initState();
    loadDbTags();
  }

  void loadDbTags() async {
    List<TagDbModel> tags = StoryTagsService.instance.tags;

    setItems() {
      dbTags = tags;
      dbTags = dbTags!.where((e) {
        return widget.tags.contains(e.id.toString());
      }).toList();
    }

    dbTags == null ? setState(setItems) : setItems();
  }

  @override
  void didUpdateWidget(covariant StoryTileTagChips oldWidget) {
    loadDbTags();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!widget.showZero) {
      return SpCrossFade(
        showFirst: dbTags == null,
        alignment: Alignment.center,
        firstChild: buildChip(dbTags ?? [], context),
        secondChild: buildChip(dbTags ?? [], context),
      );
    } else {
      return buildChip(dbTags ?? [], context);
    }
  }

  Widget buildChip(List<TagDbModel> dbTags, BuildContext context) {
    return SpChip(
      labelText: dbTags.length == 1 ? dbTags.first.title : widget.tags.length.toString(),
      avatar: Icon(
        CommunityMaterialIcons.tag,
        size: ConfigConstant.iconSize1,
        color: M3Color.of(context).onSurface,
      ),
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
