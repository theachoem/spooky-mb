part of explore_view;
class _ExploreDesktop extends StatelessWidget {
  final ExploreViewModel viewModel;
  _ExploreDesktop(this.viewModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('ExploreDesktop')),
    );
  }
}