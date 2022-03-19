part of sound_list_view;

class _SoundListMobile extends StatelessWidget {
  final SoundListViewModel viewModel;
  const _SoundListMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: SpPopButton(),
        title: SpAppBarTitle(),
      ),
      body: ListView.builder(
        itemCount: viewModel.soundsList?.sounds.length ?? 0,
        itemBuilder: (context, index) {
          SoundModel sound = viewModel.soundsList!.sounds[index];
          return ListTile(
            title: Text(sound.soundName.capitalize),
            subtitle: Text("${sound.fileSize / 1000000} mb"),
            trailing: viewModel.fileManager.downloaded(sound) || sound.asset != null ? null : Icon(Icons.download),
            onTap: () {
              viewModel.download(sound);
            },
          );
        },
      ),
    );
  }
}
