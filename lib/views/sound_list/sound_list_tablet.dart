part of sound_list_view;

class _SoundListTablet extends StatelessWidget {
  final SoundListViewModel viewModel;
  const _SoundListTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('SoundListTablet')),
    );
  }
}
