part of explore_view;

class _ExploreMobile extends StatelessWidget {
  final ExploreViewModel viewModel;
  const _ExploreMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('ExploreMobile')),
    );
  }
}
