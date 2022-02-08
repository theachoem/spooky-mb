part of init_pick_color_view;

class _InitPickColorDesktop extends StatelessWidget {
  final InitPickColorViewModel viewModel;
  const _InitPickColorDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('InitPickColorDesktop')),
    );
  }
}
