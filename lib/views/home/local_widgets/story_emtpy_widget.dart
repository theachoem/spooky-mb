import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/main/main_view_model.dart';
import 'package:spooky/widgets/sp_button.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';

class StoryEmptyWidget extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  StoryEmptyWidget({
    Key? key,
    this.isEmpty = true,
    required this.pathType,
  }) : super(key: key) {
    load();
  }

  final bool isEmpty;
  final PathType? pathType;

  late final String title;
  late final IconData iconData;

  void load() {
    switch (pathType) {
      case PathType.docs:
      case null:
        title = "What did you have in mind?";
        iconData = Icons.color_lens;
        break;
      case PathType.bins:
        title = "Empty";
        iconData = Icons.delete;
        break;
      case PathType.archives:
        title = "Empty";
        iconData = Icons.archive;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEmpty,
      child: buildBody(),
    );
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
                  Transform.scale(
                    scale: 1.5,
                    child: ImageIcon(
                      AssetImage("assets/illustrations/two_people.png"),
                      size: 200,
                      color: M3Color.of(context).primary,
                    ),
                  ),
                  // buildIcon(value, context),
                  // ConfigConstant.sizedBoxH2,
                  buildContent(value, context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildContent(int value, BuildContext context) {
    return AnimatedContainer(
      duration: ConfigConstant.duration,
      transform: Matrix4.identity()..translate(0.0, value == 1 ? 0 : -ConfigConstant.margin0),
      child: AnimatedOpacity(
        opacity: value == 1 ? 1 : 0,
        duration: ConfigConstant.duration,
        child: Column(
          children: [
            Text(
              title,
              style: M3TextTheme.of(context).bodyLarge,
              textAlign: TextAlign.center,
            ),
            ConfigConstant.sizedBoxH1,
            buildSubtitle(context) ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget? buildSubtitle(BuildContext context) {
    switch (pathType) {
      case PathType.docs:
      case null:
      // int docsCount = StoryDatabase.instance.getDocsCount(context.read<MainViewModel>().year);
      // if (docsCount > 0) return null;
      // return SpButton(
      //   label: "Add",
      //   backgroundColor: Colors.transparent,
      //   foregroundColor: M3Color.of(context).primary,
      //   borderColor: M3Color.of(context).primary,
      //   onTap: () {},
      // );
      case PathType.bins:
      case PathType.archives:
        return null;
    }
  }

  void Function()? iconPressedCallback(BuildContext context) {
    switch (pathType) {
      case PathType.docs:
      case null:
        return () => Navigator.of(context).pushNamed(SpRouter.themeSetting.path);
      case PathType.bins:
      case PathType.archives:
        return null;
    }
  }

  Widget buildIcon(int value, BuildContext context) {
    return SpTapEffect(
      onTap: iconPressedCallback(context),
      child: AnimatedContainer(
        duration: ConfigConstant.duration,
        transform: Matrix4.identity()..translate(0.0, value == 1 ? 0 : ConfigConstant.margin0),
        child: AnimatedOpacity(
          opacity: value == 1 ? 1 : 0,
          duration: ConfigConstant.duration,
          child: CircleAvatar(
            backgroundColor: fetchIconBgColor(context),
            child: Icon(
              iconData,
              color: M3Color.of(context).surface,
              size: ConfigConstant.iconSize3,
            ),
          ),
        ),
      ),
    );
  }

  Color fetchIconBgColor(BuildContext context) {
    switch (pathType) {
      case PathType.docs:
      case null:
        return M3Color.of(context).primary;
      case PathType.bins:
        return M3Color.of(context).error;
      case PathType.archives:
        return M3Color.of(context).tertiary;
    }
  }
}
