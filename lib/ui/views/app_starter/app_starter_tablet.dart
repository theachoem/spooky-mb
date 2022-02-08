part of app_starter_view;

class _AppStarterTablet extends StatelessWidget {
  final AppStarterViewModel viewModel;
  const _AppStarterTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('AppStarterTablet')),
    );
  }
}
