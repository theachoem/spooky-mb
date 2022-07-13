import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/db/databases/tag_database.dart';
import 'package:spooky/core/db/models/tag_db_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/utils/extensions/string_extension.dart';
import 'package:spooky/utils/mixins/scaffold_end_drawerable_mixin.dart';
import 'package:spooky/views/detail/detail_view.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_sections_tiles.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class SearchScaffold extends StatefulWidget {
  const SearchScaffold({
    Key? key,
    required this.resultBuilder,
    required this.titleBuilder,
    required this.initialQuery,
  }) : super(key: key);

  final StoryQueryOptionsModel? initialQuery;
  final Widget Function(void Function(String) setQuery) titleBuilder;
  final Widget Function(StoryQueryOptionsModel) resultBuilder;

  @override
  State<SearchScaffold> createState() => _SearchScaffoldState();
}

class _SearchScaffoldState extends State<SearchScaffold> with ScaffoldEndDrawableMixin {
  List<TagDbModel>? tags;
  late StoryQueryOptionsModel queryOption;

  Future<void> load() async {
    tags = await TagDatabase.instance.fetchAll().then((value) => value?.items);
    setState(() {});
  }

  @override
  void initState() {
    load();
    queryOption = widget.initialQuery ?? StoryQueryOptionsModel(type: PathType.docs);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: endDrawerScaffoldKey,
      endDrawer: buildEndDrawer(context),
      appBar: MorphingAppBar(
        // avoid conflict hero with home
        heroTag: ModalRoute.of(context)?.settings.name == "/" ? "MorphingAppBar" : DetailView.appBarHeroKey,
        title: widget.titleBuilder((text) {
          setState(() {
            queryOption = queryOption.copyWith(
              query: text.trim().isNotEmpty ? text.trim() : null,
            );
          });
        }),
        leading: ModalRoute.of(context)?.settings.name == "/" ? null : const SpPopButton(),
        actions: [
          buildEndDrawerButton(Icons.tune),
        ],
      ),
      body: widget.resultBuilder(queryOption),
    );
  }

  @override
  Widget buildEndDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: SpSectionsTiles.divide(
          context: context,
          sections: [
            SpSectionContents(
              headline: "Options",
              tiles: [
                CheckboxListTile(
                  value: queryOption.starred,
                  title: const Text("Starred"),
                  onChanged: (value) {
                    setState(() {
                      queryOption = queryOption.copyWith(starred: value);
                    });
                  },
                ),
              ],
            ),
            buildTypes(),
            buildTagsSection(),
          ],
        ),
      ),
    );
  }

  SpSectionContents buildTypes() {
    return SpSectionContents(
      headline: "Types",
      leadingIcon: Icons.folder,
      tiles: PathType.values.map(
        (path) {
          return RadioListTile<PathType>(
            groupValue: queryOption.type,
            value: path,
            title: Text(path.name.capitalize),
            onChanged: (value) {
              setState(() {
                queryOption = queryOption.copyWith(type: path);
              });
            },
          );
        },
      ).toList(),
    );
  }

  SpSectionContents buildTagsSection() {
    return SpSectionContents(
      headline: "Tags",
      leadingIcon: CommunityMaterialIcons.tag,
      tiles: [
        ...tags ?? [],
      ].map(
        (tag) {
          return RadioListTile<String>(
            groupValue: queryOption.tag,
            value: tag.id.toString(),
            title: Text(tag.title),
            onChanged: (value) {
              setState(() {
                queryOption = queryOption.copyWith(tag: tag.id.toString());
              });
            },
          );
        },
      ).toList()
        ..add(RadioListTile<String>(
          groupValue: queryOption.tag ?? "0",
          value: "0",
          title: const Text("None"),
          onChanged: (value) {
            setState(() {
              queryOption = queryOption.copyWith(tag: null);
            });
          },
        )),
    );
  }
}
