part of 'archives_view.dart';

class _ArchivesAdaptive extends StatelessWidget {
  const _ArchivesAdaptive(this.viewModel);

  final ArchivesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Archives"),
      ),
    );
  }
}
