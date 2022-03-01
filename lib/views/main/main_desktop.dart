part of main_view;

class _MainDesktop extends StatelessWidget {
  final MainViewModel viewModel;
  const _MainDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('MainDesktop'),
      ),
    );
  }
}
