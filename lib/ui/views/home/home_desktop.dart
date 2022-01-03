part of home_view;

class _HomeDesktop extends StatelessWidget {
  final HomeViewModel viewModel;
  const _HomeDesktop(
    this.viewModel, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desktop'),
        backgroundColor: Colors.amber,
      ),
      body: const Center(),
    );
  }
}
