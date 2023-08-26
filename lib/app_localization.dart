part of 'main.dart';

class AppLocalization extends StatelessWidget {
  const AppLocalization({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: AppConstant.supportedLocales,
      fallbackLocale: AppConstant.fallbackLocale,
      path: 'translations',
      assetLoader: const YamlAssetLoader(),
      child: child,
    );
  }
}
