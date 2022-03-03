part of cloud_storage_view;

class _CloudStorageMobile extends StatelessWidget {
  final CloudStorageViewModel viewModel;
  const _CloudStorageMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('CloudStorageMobile'),
      ),
    );
  }
}
