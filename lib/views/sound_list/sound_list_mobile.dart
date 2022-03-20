part of sound_list_view;

class _SoundListMobile extends StatelessWidget {
  final SoundListViewModel viewModel;
  const _SoundListMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    List<SoundType> types = SoundType.values.reversed.toList();
    return Scaffold(
      appBar: MorphingAppBar(
        leading: SpPopButton(),
        title: SpAppBarTitle(),
      ),
      extendBody: true,
      bottomNavigationBar: Consumer<MiniSoundPlayerProvider>(
        builder: (context, provider, child) {
          return SpSingleButtonBottomNavigation(
            show: provider.currentSounds.isNotEmpty,
            buttonLabel: "Listen with mini player",
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          );
        },
      ),
      body: CustomScrollView(
        slivers: List.generate(types.length, (index) {
          return buildSounds(context, types[index], index);
        }),
      ),
    );
  }

  Widget buildSounds(BuildContext context, SoundType type, int index) {
    List<SoundModel>? sounds = viewModel.soundsList?.sounds.where((e) => e.type == type).toList();
    return SliverStickyHeader(
      header: buildHeader(context, type.name.capitalize),
      sliver: SliverPadding(
        padding: EdgeInsets.only(bottom: index == SoundType.values.length - 1 ? kToolbarHeight * 2 : 0.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              SoundModel sound = sounds![index];
              bool downloaded = viewModel.fileManager.downloaded(sound);
              double fileSize = (sound.fileSize / 100000).roundToDouble() / 10;
              return ListTile(
                leading: Consumer<MiniSoundPlayerProvider>(
                  builder: (context, provider, child) {
                    bool playing = provider.currentSound(type)?.fileName == sound.fileName;
                    return CircleAvatar(
                      backgroundColor: M3Color.dayColorsOf(context)[index % 6 + 1],
                      child: SpAnimatedIcons(
                        firstChild: Icon(Icons.pause, color: M3Color.of(context).onPrimary),
                        secondChild: Icon(Icons.music_note, color: M3Color.of(context).onPrimary),
                        showFirst: playing,
                      ),
                    );
                  },
                ),
                title: Text(sound.soundName.capitalize),
                subtitle: Text("$fileSize mb"),
                trailing: downloaded ? null : Icon(Icons.download),
                onTap: () async {
                  UserProvider userProvider = context.read<UserProvider>();
                  List<SoundModel> downloadedSounds = await viewModel.fileManager.downloadedSound();
                  MiniSoundPlayerProvider provider = context.read<MiniSoundPlayerProvider>();
                  if (downloaded) {
                    if (provider.currentSound(type)?.fileName != sound.fileName) {
                      provider.play(sound);
                    } else {
                      provider.onDismissed();
                    }
                  } else {
                    if (userProvider.purchased(ProductAsType.relexSound) || downloadedSounds.isEmpty) {
                      String? message = await MessengerService.instance
                          .showLoading(future: () async => viewModel.download(sound), context: context);
                      provider.load();
                      MessengerService.instance.showSnackBar(message ?? "Fail");
                    } else {
                      MessengerService.instance.showSnackBar(
                        "Purchase to download more.",
                        action: SnackBarAction(
                          label: "Add-ons",
                          onPressed: () {
                            Navigator.of(context).pushNamed(SpRouter.addOn.path);
                          },
                        ),
                      );
                    }
                  }
                },
              );
            },
            childCount: sounds?.length ?? 0,
          ),
        ),
      ),
    );
  }

  Container buildHeader(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ConfigConstant.margin2, vertical: ConfigConstant.margin1),
      color: M3Color.of(context).secondary,
      child: Text(
        text,
        style: M3TextTheme.of(context).titleSmall?.copyWith(color: M3Color.of(context).onSecondary),
      ),
    );
  }
}
