import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:spooky_mb/views/home/home_view_model.dart';

class HomeFlexibleSpaceBar extends StatelessWidget {
  const HomeFlexibleSpaceBar({
    super.key,
    required this.viewModel,
    required this.indicatorHeight,
  });

  final HomeViewModel viewModel;
  final double indicatorHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final FlexibleSpaceBarSettings settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;
      final double deltaExtent = settings.maxExtent - settings.minExtent;
      final double lerp = clampDouble(1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent, 0.0, 1.0);

      return Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 8.0,
          top: MediaQuery.of(context).padding.top + 8.0,
          bottom: indicatorHeight + 12,
        ),
        child: Stack(
          children: [
            buildContents(context, lerp),
            buildEndDrawerButton(context),
          ],
        ),
      );
    });
  }

  Widget buildContents(BuildContext context, double lerp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Hello Thea 🎸',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: lerpDouble(14, 12, lerp)),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return FittedBox(
                child: Text(
                  viewModel.year.toString(),
                  style: TextStyle.lerp(
                    Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w200),
                    Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w400),
                    lerp,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildEndDrawerButton(BuildContext context) {
    return Positioned(
      top: 4.0,
      right: 0,
      child: IconButton(
        icon: const Icon(Icons.color_lens),
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
        },
      ),
    );
  }
}
