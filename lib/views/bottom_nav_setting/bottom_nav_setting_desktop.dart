part of bottom_nav_setting_view;

class _BottomNavSettingDesktop extends StatelessWidget {
  final BottomNavSettingViewModel viewModel;
  const _BottomNavSettingDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('BottomNavSettingDesktop'),
      ),
    );
  }
}
