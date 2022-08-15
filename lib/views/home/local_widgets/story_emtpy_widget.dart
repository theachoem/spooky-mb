import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/gen/assets.gen.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';

class StoryEmptyWidget extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  StoryEmptyWidget({
    Key? key,
    this.isEmpty = true,
    required String? imageKey,
    required this.pathType,
  }) : super(key: key) {
    loadContent();
    imagePath = getImagePath(imageKey);
  }

  final bool isEmpty;
  final PathType? pathType;

  late final String title;
  late final IconData iconData;
  late final String imagePath;

  String getImagePath(String? imageKey) {
    int? month = int.tryParse(imageKey ?? "");

    if (month != null) {
      Map<int, String> dateMap = {
        DateTime.january: Assets.illustrations.absurdDesignChapter133.path,
        DateTime.february: Assets.illustrations.absurdDesignChapter102.path,
        DateTime.march: Assets.illustrations.absurdDesignChapter134.path,
        DateTime.april: Assets.illustrations.absurdDesignChapter104.path,
        DateTime.may: Assets.illustrations.absurdDesignChapter105.path,
        DateTime.june: Assets.illustrations.absurdDesignChapter106.path,
        DateTime.july: Assets.illustrations.absurdDesignChapter107.path,
        DateTime.august: Assets.illustrations.absurdDesignChapter108.path,
        DateTime.september: Assets.illustrations.absurdDesignChapter109.path,
        DateTime.october: Assets.illustrations.absurdDesignChapter110.path,
        DateTime.november: Assets.illustrations.absurdDesignChapter111.path,
        DateTime.december: Assets.illustrations.absurdDesignChapter131.path,
      };
      return dateMap[month] ?? Assets.illustrations.absurdDesignChapter132.path;
    }

    return Assets.illustrations.absurdDesignChapter133.path;
  }

  void loadContent() {
    switch (pathType) {
      case PathType.docs:
      case null:
        title = tr("msg.empty.what_did_you_have_in_mind");
        iconData = Icons.color_lens;
        break;
      case PathType.bins:
        title = tr("msg.empty.empty");
        iconData = Icons.delete;
        break;
      case PathType.archives:
        title = tr("msg.empty.empty");
        iconData = Icons.archive;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEmpty,
      child: Visibility(
        visible: isEmpty == true,
        child: buildBodyWrapped(),
      ),
    );
  }

  Widget buildBodyWrapped() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 200),
        child: TweenAnimationBuilder<int>(
          duration: ConfigConstant.duration,
          tween: IntTween(begin: 0, end: 1),
          builder: (context, value, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpTapEffect(
                  onTap: () => iconPressedCallback(context),
                  child: ImageIcon(
                    AssetImage(imagePath),
                    size: 200,
                    color: M3Color.of(context).primary,
                  ),
                ),
                ConfigConstant.sizedBoxH2,
                buildContent(value, context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildContent(int value, BuildContext context) {
    return AnimatedContainer(
      duration: ConfigConstant.duration,
      transform: Matrix4.identity()..translate(0.0, value == 1 ? 0 : -ConfigConstant.margin0),
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

  Widget buildImageWrapper(int value, BuildContext context, Widget child) {
    return SpTapEffect(
      onTap: iconPressedCallback(context),
      child: AnimatedContainer(
        duration: ConfigConstant.duration,
        transform: Matrix4.identity()..translate(0.0, value == 1 ? 0 : ConfigConstant.margin0),
        child: AnimatedOpacity(
          opacity: value == 1 ? 1 : 0,
          duration: ConfigConstant.duration,
          child: child,
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
