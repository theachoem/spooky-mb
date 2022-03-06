part of developer_mode_view;

class _DeveloperModeDesktop extends StatelessWidget {
  final DeveloperModeViewModel viewModel;
  const _DeveloperModeDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('DeveloperModeDesktop')),
    );
  }
}
