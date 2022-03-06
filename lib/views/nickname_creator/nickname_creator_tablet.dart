part of nickname_creator_view;

class _NicknameCreatorTablet extends StatelessWidget {
  final NicknameCreatorViewModel viewModel;
  const _NicknameCreatorTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('NicknameCreatorTablet')),
    );
  }
}
