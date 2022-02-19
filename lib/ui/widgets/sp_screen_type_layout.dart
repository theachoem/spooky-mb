import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

typedef WidgetBuilder = Widget Function(BuildContext);

/// Provides a builder function for different screen types
///
/// Each builder will get built based on the current device width.
/// [breakpoints] define your own custom device resolutions
/// [watch] will be built and shown when width is less than 300
/// [mobile] will be built when width greater than 300
/// [tablet] will be built when width is greater than 600
/// [desktop] will be built if width is greater than 950
class SpScreenTypeLayout extends StatelessWidget {
  final ScreenBreakpoints? breakpoints;

  final WidgetBuilder? watch;
  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;
  final void Function(SizingInformation info)? listener;

  SpScreenTypeLayout({
    Key? key,
    this.breakpoints,
    Widget? watch,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
    this.listener,
  })  : watch = _builderOrNull(watch),
        mobile = _builderOrNull(mobile)!,
        tablet = _builderOrNull(tablet),
        desktop = _builderOrNull(desktop),
        super(key: key);

  const SpScreenTypeLayout.builder({
    Key? key,
    this.breakpoints,
    this.watch,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.listener,
  }) : super(key: key);

  static WidgetBuilder? _builderOrNull(Widget? widget) {
    return widget == null ? null : ((_) => widget);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: breakpoints,
      builder: (context, sizingInformation) {
        if (listener != null) listener!(sizingInformation);
        return defaultValidator(context, sizingInformation.deviceScreenType, () {
          switch (sizingInformation.deviceScreenType) {
            case DeviceScreenType.tablet:
              if (tablet != null) return tablet!(context);
              break;
            case DeviceScreenType.desktop:
              if (desktop != null) return desktop!(context);
              if (tablet != null) return tablet!(context);
              break;
            case DeviceScreenType.watch:
              if (watch != null) return watch!(context);
              break;
            default:
              return mobile(context);
          }
          return mobile(context);
        });
      },
    );
  }

  Widget defaultValidator(BuildContext context, type, Widget Function() builder) {
    Widget screen = builder();
    if (screen is StatelessWidget) {
      Widget scaffold = screen.build(context);
      if (scaffold is Scaffold) {
        Widget? body = scaffold.body;
        if (body is Center) {
          Widget? child = body.child;
          if (child is Text || child == null) {
            return mobile(context);
          }
        }
      }
    }
    return screen;
  }
}
