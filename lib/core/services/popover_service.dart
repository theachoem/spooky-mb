import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_fade_in.dart';
import 'package:spooky/widgets/sp_scale_in.dart';

class PopoverItem {
  final String title;
  final IconData iconData;
  final void Function() onPressed;

  PopoverItem({
    required this.title,
    required this.iconData,
    required this.onPressed,
  });
}

class PopoverService {
  PopoverService._();
  static final PopoverService instance = PopoverService._();

  void show({
    required BuildContext context,
    required List<PopoverItem> items,
  }) {
    showPopover(
      context: context,
      backgroundColor: Colors.transparent,
      shadow: [],
      radius: 0,
      contentDyOffset: 2.0,
      transitionDuration: const Duration(milliseconds: 0),
      bodyBuilder: (context) => _buildPopup(context, items),
      direction: PopoverDirection.bottom,
      width: 200,
      height: kToolbarHeight * items.length,
      arrowHeight: 4,
      arrowWidth: 8,
      onPop: () {},
    );
  }

  Widget _buildPopup(BuildContext context, List<PopoverItem> items) {
    return SpScaleIn(
      curve: Curves.fastLinearToSlowEaseIn,
      transformAlignment: Alignment.center,
      duration: ConfigConstant.fadeDuration,
      child: SpFadeIn(
        child: Container(
          margin: const EdgeInsets.only(left: 12.0),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: ConfigConstant.circlarRadius1,
            color: M3Color.of(context).background,
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                items.length,
                (index) {
                  final item = items[index];
                  return buildItem(item, context);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(PopoverItem item, BuildContext context) {
    return ListTile(
      leading: Icon(item.iconData),
      title: Text(
        item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        Navigator.of(context).pop();
        item.onPressed();
      },
    );
  }
}
