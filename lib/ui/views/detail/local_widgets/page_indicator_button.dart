import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/ui/widgets/sp_cross_fade.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class PageIndicatorButton extends StatefulWidget {
  const PageIndicatorButton({
    Key? key,
    required this.controller,
    required this.pagesCount,
  }) : super(key: key);

  final PageController controller;
  final int pagesCount;

  @override
  State<PageIndicatorButton> createState() => _PageIndicatorButtonState();
}

class _PageIndicatorButtonState extends State<PageIndicatorButton> {
  int lastReportedPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      lastReportedPage = widget.controller.page?.toInt() ?? 0;
      widget.controller.addListener(listener);
    });
  }

  void listener() {
    int currentPage = widget.controller.page?.round() ?? 0;
    if (lastReportedPage != currentPage) {
      setState(() {
        lastReportedPage = currentPage;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpCrossFade(
      showFirst: widget.pagesCount > 1,
      secondChild: const SizedBox.shrink(),
      firstChild: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin1),
          height: ConfigConstant.iconSize3,
          decoration: BoxDecoration(color: M3Color.of(context).tertiary, borderRadius: ConfigConstant.circlarRadius1),
          alignment: Alignment.center,
          child: SpCrossFade(
            showFirst: lastReportedPage.isEven,
            firstChild: buildPageNumber(context),
            secondChild: buildPageNumber(context),
          ),
        ),
      ),
    );
  }

  Text buildPageNumber(BuildContext context) {
    return Text(
      "${lastReportedPage + 1}/${widget.pagesCount}",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: M3TextTheme.of(context).bodySmall?.copyWith(color: M3Color.of(context).onTertiary),
    );
  }
}
