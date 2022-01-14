part of changes_history_view;

class _ChangesHistoryDesktop extends StatelessWidget {
  final ChangesHistoryViewModel viewModel;
  const _ChangesHistoryDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('ChangesHistoryDesktop')),
    );
  }
}
