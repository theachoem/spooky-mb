part of bottom_nav_setting_view;

class _BottomNavSettingMobile extends StatelessWidget {
  final BottomNavSettingViewModel viewModel;
  const _BottomNavSettingMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('BottomNavSettingMobile'),
      ),
    );
  }
}
