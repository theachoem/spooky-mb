part of cloud_storage_view;

class _CloudStorageDesktop extends StatelessWidget {
  final CloudStorageViewModel viewModel;
  const _CloudStorageDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('CloudStorageDesktop')),
    );
  }
}
