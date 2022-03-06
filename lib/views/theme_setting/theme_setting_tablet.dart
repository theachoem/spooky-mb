part of theme_setting_view;

class _ThemeSettingTablet extends StatelessWidget {
  final ThemeSettingViewModel viewModel;
  const _ThemeSettingTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('ThemeSettingTablet')),
    );
  }
}
