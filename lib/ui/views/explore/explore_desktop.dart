part of explore_view;

class _ExploreDesktop extends StatelessWidget {
  final ExploreViewModel viewModel;
  const _ExploreDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('ExploreDesktop')),
    );
  }
}
