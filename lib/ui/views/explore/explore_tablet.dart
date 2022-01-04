part of explore_view;

class _ExploreTablet extends StatelessWidget {
  final ExploreViewModel viewModel;
  const _ExploreTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('ExploreTablet')),
    );
  }
}
