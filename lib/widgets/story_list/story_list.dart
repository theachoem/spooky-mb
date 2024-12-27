import 'package:flutter/material.dart';
import 'package:spooky/core/databases/models/collection_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/views/stories/show/show_story_view.dart';
import 'package:spooky/widgets/story_list/story_list_timeline_verticle_divider.dart';
import 'package:spooky/widgets/story_list/story_listener_builder.dart';
import 'package:spooky/widgets/story_list/story_tile_list_item.dart';

class StoryList extends StatefulWidget {
  const StoryList({
    super.key,
    this.year,
    this.tagId,
    this.type,
    this.query,
    this.viewOnly = false,
  });

  final int? year;
  final int? tagId;
  final PathType? type;
  final String? query;
  final bool viewOnly;

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
      'query': widget.query,
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

  Future<void> toggleStarred(StoryDbModel story) async {
    bool starred = story.starred == true;

    StoryDbModel updatedStory = story.copyWith(starred: !starred);
    StoryDbModel.db.set(updatedStory);

    stories = stories?.replaceElement(updatedStory);
    setState(() {});
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
            StoryDbModel story = stories!.items[index];

            return StoryListenerBuilder(
              story: story,
              onChanged: (updatedStory) {
                // content already rendered from builder to UI, no need to refresh UI with [notifyListeners];
                stories = stories?.replaceElement(updatedStory);
              },
              onDeleted: () async {
                stories = stories?.removeElement(story);
                setState(() {});
              },
              builder: (context, snapshot) {
                return StoryTileListItem(
                  showYear: true,
                  stories: stories!,
                  index: index,
                  onTap: widget.viewOnly
                      ? null
                      : () => ShowStoryRoute(id: stories!.items[index].id, story: stories!.items[index]).push(context),
                  onToggleStarred: widget.viewOnly ? null : () => toggleStarred(stories!.items[index]),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
