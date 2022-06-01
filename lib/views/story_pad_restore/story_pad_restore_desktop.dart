part of story_pad_restore_view;

class _StoryPadRestoreDesktop extends StatelessWidget {
  final StoryPadRestoreViewModel viewModel;
  const _StoryPadRestoreDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('StoryPadRestoreDesktop')),
    );
  }
}
