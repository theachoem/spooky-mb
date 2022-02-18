import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/ui/views/detail/detail_view_model.dart';
import 'package:spooky/ui/widgets/sp_cross_fade.dart';
import 'package:spooky/ui/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/ui/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class PageIndicatorButton extends StatefulWidget {
  const PageIndicatorButton({
    Key? key,
    required this.controller,
    required this.pagesCount,
    required this.viewModel,
  }) : super(key: key);

  final PageController controller;
  final int pagesCount;
  final DetailViewModel viewModel;

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
    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent),
      child: Builder(builder: (context) {
        return SpPopupMenuButton(
          fromAppBar: true,
          items: (BuildContext context) {
            return [
              SpPopMenuItem(
                title: "Page",
                subtitle: "${lastReportedPage + 1}",
                leadingIconData: Icons.pageview,
              ),
              SpPopMenuItem(
                title: "Characters",
                subtitle: widget.viewModel.currentQuillController?.document.toPlainText().length.toString(),
                leadingIconData: Icons.text_snippet,
              ),
              SpPopMenuItem(
                title: "Words",
                subtitle: widget.viewModel.currentQuillController?.document.toPlainText().split(" ").length.toString(),
                leadingIconData: Icons.text_format,
              ),
            ];
          },
          builder: (void Function() callback) {
            return SpTapEffect(
              onTap: callback,
              child: SpCrossFade(
                showFirst: widget.pagesCount > 1,
                secondChild: const SizedBox.shrink(),
                firstChild: Center(
                  child: Container(
                    // padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin1),
                    height: ConfigConstant.iconSize3,
                    alignment: Alignment.center,
                    child: SpCrossFade(
                      showFirst: lastReportedPage.isEven,
                      firstChild: buildPageNumber(context),
                      secondChild: buildPageNumber(context),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget buildPageNumber(BuildContext context) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: M3TextTheme.of(context).bodyMedium,
        children: [
          TextSpan(text: "${lastReportedPage + 1}", style: M3TextTheme.of(context).titleLarge),
          TextSpan(text: "/${widget.pagesCount}"),
        ],
      ),
    );
  }
}
