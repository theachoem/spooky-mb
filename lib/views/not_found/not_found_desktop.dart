part of not_found_view;

class _NotFoundDesktop extends StatelessWidget {
  final NotFoundViewModel viewModel;
  const _NotFoundDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('NotFoundDesktop')),
    );
  }
}
