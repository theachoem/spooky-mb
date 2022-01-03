part of explore_view;
class _ExploreTablet extends StatelessWidget {
  final ExploreViewModel viewModel;
  _ExploreTablet(this.viewModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('ExploreTablet')),
    );
  }
}