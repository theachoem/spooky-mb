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
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: M3Color.dayColorsOf(context)[index % 6 + 1],
              child: Icon(Icons.music_note),
            ),
            title: Text(sound.soundName.capitalize),
            subtitle: Text("${sound.fileSize / 1000000} mb"),
            trailing: downloaded ? null : Icon(Icons.download),
            onTap: () async {
              if (downloaded) {
                context.read<MiniSoundPlayerProvider>().play(sound);
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
