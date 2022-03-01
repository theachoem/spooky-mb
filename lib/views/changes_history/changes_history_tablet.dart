part of changes_history_view;

class _ChangesHistoryTablet extends StatelessWidget {
  final ChangesHistoryViewModel viewModel;
  const _ChangesHistoryTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('ChangesHistoryTablet')),
    );
  }
}
