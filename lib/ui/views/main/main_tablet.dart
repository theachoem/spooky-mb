part of main_view;
class _MainTablet extends StatelessWidget {
  final MainViewModel viewModel;
  _MainTablet(this.viewModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('MainTablet')),
    );
  }
}