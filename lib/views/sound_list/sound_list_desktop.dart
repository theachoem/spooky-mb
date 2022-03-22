part of sound_list_view;

class _SoundListDesktop extends StatelessWidget {
  final SoundListViewModel viewModel;
  const _SoundListDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('SoundListDesktop')),
    );
  }
}
