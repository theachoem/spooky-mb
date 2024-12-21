import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spooky/core/databases/models/collection_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/widgets/story_list/story_list_timeline_verticle_divider.dart';
import 'package:spooky/widgets/story_list/story_tile_list_item.dart';

class StoryList extends StatefulWidget {
  const StoryList({
    super.key,
    this.year,
    this.tagId,
  });

  final int? year;
  final int? tagId;

  @override
  State<StoryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> {
  CollectionDbModel<StoryDbModel>? stories;

  Future<void> load() async {
    stories = await StoryDbModel.db.where(filters: {
      'year': widget.year,
      'tag': widget.tagId,
    });

    setState(() {});
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
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: MediaQuery.of(context).padding.horizontal),
          itemCount: stories?.items.length ?? 0,
          itemBuilder: (context, index) {
            return StoryTileListItem(
              stories: stories!,
              index: index,
              onTap: () async {
                await context.push('/stories/${stories?.items[index].id}');
              },
            );
          },
        ),
      ],
    );
  }
}
