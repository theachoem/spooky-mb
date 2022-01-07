import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/file_manager/docs_manager.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/ui/widgets/sp_chip.dart';
import 'package:spooky/ui/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/utils/helpers/quill_helper.dart';
import 'package:spooky/core/route/router.gr.dart' as r;

class StoryList extends StatefulWidget {
  const StoryList({
    Key? key,
    required this.year,
    required this.month,
  }) : super(key: key);

  final int year;
  final int month;

  @override
  State<StoryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> {
  final DocsManager docsManager = DocsManager();
  List<StoryModel>? stories;

  late Map<int, Color> dayColors;

  @override
  void initState() {
    super.initState();

    load();
    setDayColors();
  }

  void setDayColors() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      dayColors = M3Color.dayColorsOf(context);
    });
  }

  Future<void> load() async {
    var result = await docsManager.fetchAll(year: widget.year, month: widget.month) ?? [];
    if (result != stories) {
      setState(() {
        stories = result;
      });
    }
  }

  @override
  void didUpdateWidget(covariant StoryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    setDayColors();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => load(),
      child: Stack(
        children: [
          ListView.separated(
            itemCount: stories?.length ?? 0,
            physics: AlwaysScrollableScrollPhysics(),
            padding: ConfigConstant.layoutPadding,
            separatorBuilder: (context, index) {
              return Divider(
                indent: 16 + 20 + 16 + 4,
                color: M3Color.of(context)?.secondary.m3Opacity.opacity016,
                height: 0,
              );
            },
            itemBuilder: (context, index) {
              final StoryModel content = stories![index];
              return SpTapEffect(
                onTap: () {
                  context.router.push(r.Detail(story: content));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: ConfigConstant.margin2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildMonogram(context, content),
                      ConfigConstant.sizedBoxW2,
                      buildContent(context, content),
                    ],
                  ),
                ),
              );
            },
          ),
          Visibility(
            visible: stories != null && stories!.isEmpty,
            child: Container(
              color: M3Color.of(context)?.background,
              alignment: Alignment.center,
              child: Text(
                "Add to " + DateFormatHelper.toFullNameOfMonth().format(DateTime(widget.year, widget.month)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent(BuildContext context, StoryModel content) {
    List<String> images = QuillHelper.imagesFromJson(content.document!);
    return Expanded(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (content.title?.trim().isNotEmpty == true)
                Container(
                  margin: const EdgeInsets.only(bottom: ConfigConstant.margin0),
                  child: Text(
                    content.title ?? "content.title",
                    style: M3TextTheme.of(context)?.titleMedium,
                  ),
                ),
              if (content.plainText?.trim().isNotEmpty == true)
                Container(
                  margin: const EdgeInsets.only(bottom: ConfigConstant.margin0),
                  child: Text(
                    content.plainText ?? "content.plainText",
                    style: M3TextTheme.of(context)?.bodyMedium,
                  ),
                ),
              if (images.isNotEmpty)
                SpChip(
                  labelText: "${images.length} Images",
                  avatar: CircleAvatar(
                    backgroundImage: NetworkImage(images.first),
                  ),
                )
            ],
          ),
          buildTime(context, content)
        ],
      ),
    );
  }

  Widget buildTime(BuildContext context, StoryModel content) {
    if (content.createdAt == null) return SizedBox.shrink();
    return Positioned(
      right: 0,
      child: Row(
        children: [
          if (content.starred == true)
            Icon(
              Icons.favorite,
              size: ConfigConstant.iconSize1,
              color: M3Color.of(context)?.error,
            ),
          ConfigConstant.sizedBoxW0,
          Text(
            DateFormatHelper.timeFormat().format(content.createdAt!),
            style: M3TextTheme.of(context)?.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget buildMonogram(BuildContext context, StoryModel content) {
    if (content.createdAt == null) return SizedBox.shrink();
    return Column(
      children: [
        ConfigConstant.sizedBoxH0,
        Text(DateFormatHelper.toDay().format(content.createdAt!).toString()),
        ConfigConstant.sizedBoxH0,
        CircleAvatar(
          radius: 20,
          backgroundColor: dayColors[content.createdAt!.day],
          foregroundColor: M3Color.of(context)?.onPrimary,
          child: Text(content.createdAt!.day.toString()),
        ),
      ],
    );
  }
}
