part of setting_view;

class _SettingDesktop extends StatelessWidget {
  final SettingViewModel viewModel;
  const _SettingDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('SettingDesktop')),
    );
  }
}
