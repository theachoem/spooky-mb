part of nickname_creator_view;

class _NicknameCreatorDesktop extends StatelessWidget {
  final NicknameCreatorViewModel viewModel;
  const _NicknameCreatorDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('NicknameCreatorDesktop')),
    );
  }
}
