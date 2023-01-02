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
  final Color? foregroundColor;

  PopoverItem({
    required this.title,
    required this.iconData,
    required this.onPressed,
    this.foregroundColor,
  });
}

class PopoverService {
  PopoverService._();
  static final PopoverService instance = PopoverService._();

  void show({
    required BuildContext context,
    required List<PopoverItem> items,
    double contentDyOffset = 4.0,
  }) {
    showPopover(
      context: context,
      backgroundColor: Colors.transparent,
      shadow: [],
      radius: 0,
      contentDyOffset: contentDyOffset,
      transitionDuration: const Duration(milliseconds: 0),
      bodyBuilder: (context) => _buildPopup(context, items),
      direction: PopoverDirection.bottom,
      width: 200,
      height: kToolbarHeight * items.length + 2,
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
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
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
                  return buildItem(
                    item,
                    context,
                    first: index == 0,
                    last: index == items.length - 1,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(
    PopoverItem item,
    BuildContext context, {
    bool first = false,
    bool last = false,
  }) {
    return ListTile(
      leading: Icon(item.iconData, color: item.foregroundColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: first ? const Radius.circular(ConfigConstant.radius1 - 1) : Radius.zero,
          bottom: last ? const Radius.circular(ConfigConstant.radius1 - 1) : Radius.zero,
        ),
      ),
      title: Text(
        item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: item.foregroundColor),
      ),
      onTap: () {
        Navigator.of(context).pop();
        item.onPressed();
      },
    );
  }
}
