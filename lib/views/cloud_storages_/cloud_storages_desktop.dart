part of clouds_storage_view;

class _CloudStoragesDesktop extends StatelessWidget {
  final CloudStoragesViewModel viewModel;
  const _CloudStoragesDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('CloudStoragesDesktop')),
    );
  }
}
