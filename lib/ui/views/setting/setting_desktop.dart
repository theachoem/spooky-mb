part of setting_view;
class _SettingDesktop extends StatelessWidget {
  final SettingViewModel viewModel;
  _SettingDesktop(this.viewModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('SettingDesktop')),
    );
  }
}