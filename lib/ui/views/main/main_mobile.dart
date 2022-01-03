part of main_view;
class _MainMobile extends StatelessWidget {
  final MainViewModel viewModel;
  _MainMobile(this.viewModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('MainMobile')),
    );
  }
}