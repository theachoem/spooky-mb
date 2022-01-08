import 'package:flutter/material.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/ui/widgets/sp_chip.dart';
import 'package:spooky/ui/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/utils/helpers/quill_helper.dart';
import 'package:spooky/core/route/router.dart' as route;

class StoryList extends StatelessWidget {
  const StoryList({
    Key? key,
    required this.onRefresh,
    required this.stories,
    this.emptyMessage = "",
  }) : super(key: key);
  final Future<void> Function() onRefresh;

  final List<StoryModel>? stories;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    Map<int, Color> dayColors = M3Color.dayColorsOf(context);
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Stack(
        children: [
          ListView.separated(
            itemCount: stories?.length ?? 0,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: ConfigConstant.layoutPadding,
            separatorBuilder: (context, index) {
              return Divider(
                indent: 16 + 20 + 16 + 4,
                color: M3Color.of(context).secondary.m3Opacity.opacity016,
                height: 0,
              );
            },
            itemBuilder: (context, index) {
              final StoryModel content = stories![index];
              return SpTapEffect(
                onTap: () {
                  route.Detail page = route.Detail(
                    story: content.copyWith(
                      documentId: content.documentId ?? StoryModel.documentIdFromDate(DateTime.now()),
                      pathDate: content.pathDate ?? content.createdAt ?? DateTime.now(),
                    ),
                  );
                  context.router.push(page).then(
                    (value) {
                      if (value is StoryModel && value.documentId != null) {
                        onRefresh();
                      }
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: ConfigConstant.margin2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildMonogram(context, content, dayColors),
                      ConfigConstant.sizedBoxW2,
                      buildContent(context, content),
                    ],
                  ),
                ),
              );
            },
          ),
          IgnorePointer(
            child: Visibility(
              visible: stories?.isEmpty == true,
              child: Container(
                alignment: Alignment.center,
                child: Text(emptyMessage),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMonogram(BuildContext context, StoryModel content, Map<int, Color> dayColors) {
    DateTime? displayDate = content.pathDate ?? content.createdAt;
    if (displayDate == null) return SizedBox.shrink();
    return Column(
      children: [
        ConfigConstant.sizedBoxH0,
        Text(DateFormatHelper.toDay().format(displayDate).toString()),
        ConfigConstant.sizedBoxH0,
        CircleAvatar(
          radius: 20,
          backgroundColor: dayColors.keys.contains(displayDate.weekday)
              ? dayColors[displayDate.weekday]
              : M3Color.of(context).primary,
          foregroundColor: M3Color.of(context).onPrimary,
          child: Text(displayDate.day.toString()),
        ),
      ],
    );
  }

  Widget buildContent(BuildContext context, StoryModel content) {
    List<String> images = QuillHelper.imagesFromJson(content.document ?? []);
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
                    style: M3TextTheme.of(context).titleMedium,
                  ),
                ),
              if (content.plainText != null && content.plainText!.trim().length > 1)
                Container(
                  margin: const EdgeInsets.only(bottom: ConfigConstant.margin0),
                  child: Text(
                    content.plainText?.trim() ?? "content.plainText",
                    style: M3TextTheme.of(context).bodyMedium,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
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
              color: M3Color.of(context).error,
            ),
          ConfigConstant.sizedBoxW0,
          Text(
            DateFormatHelper.timeFormat().format(content.createdAt!),
            style: M3TextTheme.of(context).bodySmall,
          ),
        ],
      ),
    );
  }
}
