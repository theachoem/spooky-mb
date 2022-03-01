part of main_view;

class _MainTablet extends StatelessWidget {
  final MainViewModel viewModel;
  const _MainTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('MainTablet')),
    );
  }
}
