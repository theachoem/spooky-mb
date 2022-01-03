part of setting_view;
class _SettingTablet extends StatelessWidget {
  final SettingViewModel viewModel;
  _SettingTablet(this.viewModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('SettingTablet')),
    );
  }
}