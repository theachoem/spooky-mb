part of bottom_nav_setting_view;

class _BottomNavSettingTablet extends StatelessWidget {
  final BottomNavSettingViewModel viewModel;

  const _BottomNavSettingTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('BottomNavSettingTablet'),
      ),
    );
  }
}
