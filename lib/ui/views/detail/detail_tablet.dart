part of detail_view;
class _DetailTablet extends StatelessWidget {
  final DetailViewModel viewModel;
  _DetailTablet(this.viewModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('DetailTablet')),
    );
  }
}