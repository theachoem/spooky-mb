import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/databases/models/collection_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/views/home/home_view_model.dart';
import 'package:spooky/views/stories/changes/show/show_change_view.dart';
import 'package:spooky/views/stories/show/show_story_view.dart';
import 'package:spooky/widgets/story_list/story_list_timeline_verticle_divider.dart';
import 'package:spooky/widgets/story_list/story_listener_builder.dart';
import 'package:spooky/widgets/story_list/story_tile_list_item.dart';

class StoryList extends StatefulWidget {
  const StoryList({
    super.key,
    this.year,
    this.tagId,
    this.types,
    this.query,
    this.viewOnly = false,
  });

  final int? year;
  final int? tagId;
  final List<PathType>? types;
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
      'types': widget.types?.map((t) => t.name).toList(),
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

  Future<void> putBack(StoryDbModel story, BuildContext context) async {
    await story.putBack();
    if (context.mounted) context.read<HomeViewModel>().load();
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
            final story = stories!.items[index];
            return StoryListenerBuilder(
              story: story,
              key: ValueKey(story.id),
              onChanged: (StoryDbModel updatedStory) {
                if (widget.types?.contains(updatedStory.type) == true) {
                  stories = stories?.replaceElement(updatedStory);
                } else {
                  stories = stories?.removeElement(updatedStory);
                }
                setState(() {});
              },
              // onDeleted only happen when reloaded story is null which not frequently happen. We just reload in this case.
              onDeleted: () => load(),
              builder: (context) {
                return StoryTileListItem(
                  showYear: true,
                  stories: stories!,
                  index: index,
                  viewOnly: widget.viewOnly,
                  onTap: () {
                    if (widget.viewOnly) {
                      ShowChangeRoute(content: story.latestChange!).push(context);
                    } else {
                      ShowStoryRoute(id: story.id, story: story).push(context);
                    }
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
