part of home_view;

class _HomeMobile extends StatelessWidget {
  final HomeViewModel viewModel;

  const _HomeMobile(
    this.viewModel, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: TextButton(
          child: Text("Detail"),
          onPressed: () {
            context.router.push(
              r.Detail(),
            );
          },
        ),
      ),
    );
  }
}
