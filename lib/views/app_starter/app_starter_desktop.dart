part of app_starter_view;

class _AppStarterDesktop extends StatelessWidget {
  final AppStarterViewModel viewModel;
  const _AppStarterDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('AppStarterDesktop')),
    );
  }
}
