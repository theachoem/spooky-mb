part of '../home_view.dart';

class _TimelineVerticleDivider extends StatelessWidget {
  const _TimelineVerticleDivider();

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 0,
      bottom: 0,
      left: 16.0 + _circleSize / 2,
      child: VerticalDivider(
        width: 1,
      ),
    );
  }
}
