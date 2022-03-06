part of cloud_storage_view;

class _CloudStorageTablet extends StatelessWidget {
  final CloudStorageViewModel viewModel;
  const _CloudStorageTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('CloudStorageTablet')),
    );
  }
}
