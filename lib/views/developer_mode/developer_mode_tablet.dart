part of developer_mode_view;

class _DeveloperModeTablet extends StatelessWidget {
  final DeveloperModeViewModel viewModel;
  const _DeveloperModeTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('DeveloperModeTablet')),
    );
  }
}
