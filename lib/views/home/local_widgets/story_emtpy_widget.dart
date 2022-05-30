import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';

class StoryEmptyWidget extends StatelessWidget {
  const StoryEmptyWidget({
    Key? key,
    this.isEmpty = true,
  }) : super(key: key);

  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEmpty,
      child: buildBody(),
    );
  }

  bool archived(BuildContext context) {
    return ModalRoute.of(context)?.settings.name == SpRouter.archive.path;
  }

  Widget buildBody() {
    return Visibility(
      visible: isEmpty == true,
      child: Container(
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: TweenAnimationBuilder<int>(
            duration: ConfigConstant.duration,
            tween: IntTween(begin: 0, end: 1),
            builder: (context, value, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildIcon(value, context),
                  ConfigConstant.sizedBoxH2,
                  buildContent(value, context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildSubtitle(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: M3TextTheme.of(context).bodyMedium,
        children: const [
          TextSpan(
            text: "Click",
          ),
          WidgetSpan(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Icon(
                CommunityMaterialIcons.pencil,
                size: ConfigConstant.iconSize1,
              ),
            ),
          ),
          TextSpan(
            text: "to add a story",
          ),
        ],
      ),
    );
  }

  Widget buildContent(int value, BuildContext context) {
    bool isArchive = archived(context);
    return AnimatedContainer(
      duration: ConfigConstant.duration,
      transform: Matrix4.identity()..translate(0.0, value == 1 ? 0 : -ConfigConstant.margin0),
      child: AnimatedOpacity(
        opacity: value == 1 ? 1 : 0,
        duration: ConfigConstant.duration,
        child: Column(
          children: [
            Text(
              isArchive ? "Empty" : "New here?",
              style: M3TextTheme.of(context).bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (!isArchive) buildSubtitle(context),
          ],
        ),
      ),
    );
  }

  Widget buildIcon(int value, BuildContext context) {
    return SpTapEffect(
      onTap: () => Navigator.of(context).pushNamed(SpRouter.themeSetting.path),
      child: AnimatedContainer(
        duration: ConfigConstant.duration,
        transform: Matrix4.identity()..translate(0.0, value == 1 ? 0 : ConfigConstant.margin0),
        child: AnimatedOpacity(
          opacity: value == 1 ? 1 : 0,
          duration: ConfigConstant.duration,
          child: CircleAvatar(
            backgroundColor: M3Color.of(context).primary,
            child: Icon(
              archived(context) ? Icons.archive : Icons.color_lens,
              color: M3Color.of(context).surface,
              size: ConfigConstant.iconSize3,
            ),
          ),
        ),
      ),
    );
  }
}
