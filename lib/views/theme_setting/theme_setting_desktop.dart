part of theme_setting_view;

class _ThemeSettingDesktop extends StatelessWidget {
  final ThemeSettingViewModel viewModel;
  const _ThemeSettingDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('ThemeSettingDesktop')),
    );
  }
}
