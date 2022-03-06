part of not_found_view;

class _NotFoundTablet extends StatelessWidget {
  final NotFoundViewModel viewModel;
  const _NotFoundTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('NotFoundTablet')),
    );
  }
}
