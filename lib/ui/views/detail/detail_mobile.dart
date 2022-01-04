part of detail_view;

class _DetailMobile extends StatelessWidget {
  final DetailViewModel viewModel;
  const _DetailMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      body: const Center(
        child: Text('DetailMobile'),
      ),
    );
  }
}
