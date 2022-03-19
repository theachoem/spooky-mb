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
          bool downloaded = viewModel.fileManager.downloaded(sound);
          double fileSize = (sound.fileSize / 100000).roundToDouble() / 10;
          return ListTile(
            leading: Consumer<MiniSoundPlayerProvider>(
              builder: (context, provider, child) {
                return CircleAvatar(
                  backgroundColor: M3Color.dayColorsOf(context)[index % 6 + 1],
                  child: SpAnimatedIcons(
                    firstChild: Icon(Icons.pause, color: M3Color.of(context).onPrimary),
                    secondChild: Icon(Icons.music_note, color: M3Color.of(context).onPrimary),
                    showFirst: provider.currentSound == sound,
                  ),
                );
              },
            ),
            title: Text(sound.soundName.capitalize),
            subtitle: Text("$fileSize mb"),
            trailing: downloaded ? null : Icon(Icons.download),
            onTap: () async {
              if (downloaded) {
                MiniSoundPlayerProvider provider = context.read<MiniSoundPlayerProvider>();
                if (provider.currentSound != sound) {
                  provider.play(sound);
                } else {
                  provider.onDismissed();
                }
              } else {
                String? message = await MessengerService.instance
                    .showLoading(future: () async => viewModel.download(sound), context: context);
                MessengerService.instance.showSnackBar(message ?? "Fail");
              }
            },
          );
        },
      ),
    );
  }
}
