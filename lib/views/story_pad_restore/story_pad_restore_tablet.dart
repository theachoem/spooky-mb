part of story_pad_restore_view;

class _StoryPadRestoreTablet extends StatelessWidget {
  final StoryPadRestoreViewModel viewModel;
  const _StoryPadRestoreTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('StoryPadRestoreTablet')),
    );
  }
}
