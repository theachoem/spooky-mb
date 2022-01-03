part of setting_view;
class _SettingMobile extends StatelessWidget {
  final SettingViewModel viewModel;
  _SettingMobile(this.viewModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('SettingMobile')),
    );
  }
}