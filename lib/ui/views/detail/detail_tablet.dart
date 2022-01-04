part of detail_view;

class _DetailTablet extends StatelessWidget {
  final DetailViewModel viewModel;
  const _DetailTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('DetailTablet')),
    );
  }
}
