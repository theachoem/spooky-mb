part of 'backups_view.dart';

class _BackupsAdaptive extends StatelessWidget {
  const _BackupsAdaptive(this.viewModel);

  final BackupsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Backups"),
      ),
    );
  }
}
