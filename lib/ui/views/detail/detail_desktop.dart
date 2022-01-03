part of detail_view;
class _DetailDesktop extends StatelessWidget {
  final DetailViewModel viewModel;
  _DetailDesktop(this.viewModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('DetailDesktop')),
    );
  }
}