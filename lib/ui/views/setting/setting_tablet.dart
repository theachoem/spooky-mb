part of setting_view;

class _SettingTablet extends StatelessWidget {
  final SettingViewModel viewModel;
  const _SettingTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('SettingTablet')),
    );
  }
}
