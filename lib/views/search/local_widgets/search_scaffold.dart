import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/db/models/tag_db_model.dart';
import 'package:spooky/core/locale/type_localization.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/services/story_tags_service.dart';
import 'package:spooky/core/types/path_type.dart';
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
  final Widget Function(StoryQueryOptionsModel?) resultBuilder;

  @override
  State<SearchScaffold> createState() => _SearchScaffoldState();
}

class _SearchScaffoldState extends State<SearchScaffold> with ScaffoldEndDrawableMixin {
  List<TagDbModel>? tags;
  StoryQueryOptionsModel? queryOption;
  bool advanceSearch = false;

  Future<void> load() async {
    await StoryTagsService.instance.load();
    tags = StoryTagsService.instance.tags;
    setState(() {});
  }

  @override
  void initState() {
    load();
    queryOption = widget.initialQuery;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: endDrawerScaffoldKey,
      endDrawer: buildEndDrawer(context),
      appBar: MorphingAppBar(
        // avoid conflict hero with home
        heroTag: ModalRoute.of(context)?.settings.name == "/" ? "MorphingAppBar" : DetailView.appBarHeroKey,
        title: widget.titleBuilder((text) {
          if (advanceSearch) {
            List<int>? selectedYears;
            List<int>? yearsRange;

            List<String> years = text.split(",");
            List<String> yearsRanges = text.split("-");

            if (yearsRanges.length == 2) {
              int? from = int.tryParse(yearsRanges[0]);
              int? to = int.tryParse(yearsRanges[1]);
              if (from != null && to != null) yearsRange = [from, to];
            } else if (years.isNotEmpty) {
              List<int?> selected = years.map((year) {
                return int.tryParse(year);
              }).toList();
              if (!selected.contains(null)) {
                selectedYears = selected.map((e) => e as int).toList();
              }
            }

            setState(() {
              queryOption ??= StoryQueryOptionsModel();
              queryOption = queryOption!.copyWith(
                query: yearsRange != null || selectedYears != null || text.trim().isEmpty ? null : text.trim(),
                selectedYears: selectedYears,
                yearsRange: yearsRange,
              );
            });
          } else {
            setState(() {
              queryOption ??= StoryQueryOptionsModel();
              queryOption = queryOption!.copyWith(
                query: text.trim().isEmpty ? null : text.trim(),
              );
            });
          }
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
            buildTypes(),
            buildTagsSection(),
            SpSectionContents(
              headline: tr("sections.options"),
              tiles: [
                CheckboxListTile(
                  value: queryOption?.starred == true,
                  title: Text(tr("tile.starred.title")),
                  onChanged: (value) {
                    setState(() {
                      queryOption ??= StoryQueryOptionsModel();
                      queryOption = queryOption!.copyWith(starred: value);
                    });
                  },
                ),
                CheckboxListTile(
                  value: advanceSearch,
                  title: Text(tr("title.advance_search.title")),
                  onChanged: (value) {
                    setState(() {
                      advanceSearch = !advanceSearch;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SpSectionContents buildTypes() {
    return SpSectionContents(
      headline: tr("section.types"),
      leadingIcon: Icons.folder,
      tiles: PathType.values.map(
        (path) {
          return RadioListTile<PathType>(
            groupValue: queryOption?.type,
            value: path,
            title: Text(TypeLocalization.pathType(path)),
            onChanged: (value) {
              setState(() {
                queryOption ??= StoryQueryOptionsModel();
                queryOption = queryOption!.copyWith(type: path);
              });
            },
          );
        },
      ).toList(),
    );
  }

  SpSectionContents buildTagsSection() {
    return SpSectionContents(
      headline: tr("section.tags"),
      leadingIcon: CommunityMaterialIcons.tag,
      tiles: [
        ...tags ?? [],
      ].map(
        (tag) {
          return RadioListTile<String>(
            groupValue: queryOption?.tag,
            value: tag.id.toString(),
            title: Text(tag.title),
            onChanged: (value) {
              setState(() {
                queryOption ??= StoryQueryOptionsModel();
                queryOption = queryOption!.copyWith(tag: tag.id.toString());
              });
            },
          );
        },
      ).toList()
        ..add(RadioListTile<String>(
          groupValue: queryOption?.tag ?? "0",
          value: "0",
          title: Text(tr("tile.none.title")),
          onChanged: (value) {
            setState(() {
              queryOption ??= StoryQueryOptionsModel();
              queryOption = queryOption!.copyWith(tag: null);
            });
          },
        )),
    );
  }
}
