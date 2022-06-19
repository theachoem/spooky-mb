part of clouds_storage_view;

class _CloudStoragesTablet extends StatelessWidget {
  final CloudStoragesViewModel viewModel;
  const _CloudStoragesTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('CloudStoragesTablet')),
    );
  }
}
