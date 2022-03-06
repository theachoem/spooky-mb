part of not_found_view;

class _NotFoundMobile extends StatelessWidget {
  final NotFoundViewModel viewModel;
  const _NotFoundMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: const SpPopButton(),
        title: Text(
          "Security",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Center(
        child: Text("Not found"),
      ),
    );
  }
}
