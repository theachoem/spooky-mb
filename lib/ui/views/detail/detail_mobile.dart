part of detail_view;
class _DetailMobile extends StatelessWidget {
  final DetailViewModel viewModel;
  _DetailMobile(this.viewModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('DetailMobile')),
    );
  }
}