part of detail_view;

class _DetailDesktop extends StatelessWidget {
  final DetailViewModel viewModel;
  const _DetailDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('DetailDesktop'),
      ),
    );
  }
}
