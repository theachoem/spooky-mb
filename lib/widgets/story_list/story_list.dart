import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spooky/core/databases/models/collection_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/widgets/story_list/story_list_timeline_verticle_divider.dart';
import 'package:spooky/widgets/story_list/story_tile_list_item.dart';

class StoryList extends StatefulWidget {
  const StoryList({
    super.key,
    this.year,
    this.tagId,
    this.type,
  });

  final int? year;
  final int? tagId;
  final PathType? type;

  @override
  State<StoryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> {
  CollectionDbModel<StoryDbModel>? stories;

  Future<void> load() async {
    stories = await StoryDbModel.db.where(filters: {
      'year': widget.year,
      'tag': widget.tagId,
      'type': widget.type?.name,
    });

    setState(() {});
  }

  @override
  void didUpdateWidget(covariant StoryList oldWidget) {
    super.didUpdateWidget(oldWidget);

    load();
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (stories?.items == null) return const Center(child: CircularProgressIndicator.adaptive());
    return Stack(
      children: [
        const StoryListTimelineVerticleDivider(),
        ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16.0)
              .copyWith(left: MediaQuery.of(context).padding.left, right: MediaQuery.of(context).padding.right),
          itemCount: stories?.items.length ?? 0,
          itemBuilder: (context, index) {
            return StoryTileListItem(
              stories: stories!,
              index: index,
              onTap: () async {
                await context.push('/stories/${stories?.items[index].id}');
                await load();
              },
            );
          },
        ),
      ],
    );
  }
}
