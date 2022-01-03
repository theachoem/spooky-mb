part of explore_view;
class _ExploreMobile extends StatelessWidget {
  final ExploreViewModel viewModel;
  _ExploreMobile(this.viewModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('ExploreMobile')),
    );
  }
}