import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/ui/widgets/sp_cross_fade.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class DetailScaffold extends StatefulWidget {
  const DetailScaffold({
    Key? key,
    required this.appBar,
    required this.editor,
    required this.toolbar,
    required this.readOnlyNotifier,
  }) : super(key: key);

  final AppBar appBar;
  final Widget editor;
  final Widget toolbar;
  final ValueNotifier<bool> readOnlyNotifier;

  @override
  State<DetailScaffold> createState() => _DetailScaffoldState();
}

class _DetailScaffoldState extends State<DetailScaffold> {
  @override
  Widget build(BuildContext context) {
    EdgeInsets mediaQueryPadding = MediaQuery.of(context).padding;
    return Scaffold(
      extendBody: true,
      appBar: widget.appBar,
      floatingActionButton: buildBypassFAB(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Expanded(child: widget.editor),
              buildAdditionBottomPadding(),
            ],
          ),
          buildToolbar(context, mediaQueryPadding),
          buildFloatActionButton(mediaQueryPadding),
        ],
      ),
    );
  }

  // invisible FAB's used as fake position for
  // real FAB which is in stack to improve other widget eg. SnackBar.
  Widget buildBypassFAB() {
    return const IgnorePointer(
      child: Opacity(
        opacity: 0,
        child: SizedBox(height: kToolbarHeight),
      ),
    );
  }

  // spacing when toolbar is opened
  Widget buildAdditionBottomPadding() {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.readOnlyNotifier,
      builder: (context, value, child) {
        return SizedBox(height: value ? 0 : ConfigConstant.objectHeight1 + 8.0);
      },
    );
  }

  Widget buildFloatActionButton(EdgeInsets mediaQueryPadding) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.readOnlyNotifier,
      builder: (context, value, child) {
        double bottom = (value ? 0 : kToolbarHeight) + mediaQueryPadding.bottom + 16.0;
        return Positioned(
          bottom: 0,
          right: 0,
          child: AnimatedContainer(
            curve: Curves.linearToEaseOut,
            duration: ConfigConstant.fadeDuration,
            transform: Matrix4.identity()..translate(-16.0, -bottom),
            child: FloatingActionButton.extended(
              backgroundColor: value ? M3Color.of(context)?.secondary : M3Color.of(context)?.primary,
              foregroundColor: value ? M3Color.of(context)?.onSecondary : M3Color.of(context)?.onPrimary,
              onPressed: () {
                widget.readOnlyNotifier.value = !widget.readOnlyNotifier.value;
                bool saving = widget.readOnlyNotifier.value;
                if (saving) {
                  Future.delayed(ConfigConstant.fadeDuration).then((value) {
                    App.of(context)?.showSpSnackBar("Saved");
                  });
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              label: SpCrossFade(
                firstChild: Text("Edit"),
                secondChild: Text("Save"),
                showFirst: value,
              ),
              icon: SpCrossFade(
                firstChild: Icon(Icons.edit),
                secondChild: Icon(Icons.save),
                showFirst: value,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildToolbar(BuildContext context, EdgeInsets mediaQueryPadding) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.readOnlyNotifier,
        child: Container(
          color: M3Color.of(context)?.readOnly.surface2,
          padding: EdgeInsets.only(
            bottom: mediaQueryPadding.bottom + ConfigConstant.margin0,
            top: ConfigConstant.margin0,
          ),
          child: widget.toolbar,
        ),
        builder: (context, value, child) {
          return IgnorePointer(
            ignoring: value,
            child: AnimatedOpacity(
              opacity: value ? 0 : 1,
              duration: ConfigConstant.fadeDuration,
              curve: Curves.fastOutSlowIn,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
