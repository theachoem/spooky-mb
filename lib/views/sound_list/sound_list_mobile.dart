part of sound_list_view;

class _SoundListMobile extends StatelessWidget {
  final SoundListViewModel viewModel;
  const _SoundListMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('SoundListMobile')),
    );
  }
}
