part of sound_list_view;

class _SoundListMobile extends StatelessWidget {
  final SoundListViewModel viewModel;
  const _SoundListMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    List<SoundType> types = SoundType.values.reversed.toList();
    return Scaffold(
      appBar: buildAppBar(context),
      extendBody: true,
      body: CustomScrollView(
        slivers: List.generate(
          types.length,
          (index) {
            return buildSounds(context, types[index], index);
          },
        ),
      ),
    );
  }

  MorphingAppBar buildAppBar(BuildContext context) {
    return MorphingAppBar(
      leading: const SpPopButton(),
      title: const SpAppBarTitle(),
      actions: [
        Consumer<MiniSoundPlayerProvider>(
          child: SpIconButton(
            tooltip: "Stop",
            icon: Icon(Icons.stop_circle_outlined, color: M3Color.of(context).error),
            onPressed: () {
              context.read<MiniSoundPlayerProvider>().onDismissed();
            },
          ),
          builder: (context, provider, child) {
            return SpAnimatedIcons(
              firstChild: child!,
              secondChild: const SizedBox.shrink(),
              showFirst: provider.currentlyPlaying,
            );
          },
        ),
        Consumer<MiniSoundPlayerProvider>(
          child: SpIconButton(
            tooltip: "Listen with mini player",
            icon: Icon(Icons.branding_watermark, color: M3Color.of(context).primary),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          builder: (context, provider, child) {
            return SpAnimatedIcons(
              firstChild: child!,
              secondChild: const SizedBox.shrink(),
              showFirst: provider.currentlyPlaying,
            );
          },
        ),
        SpPopupMenuButton(items: (context) {
          return [
            SpPopMenuItem(
              title: "Play in Background",
              leadingIconData: viewModel.playSoundInBackground ? Icons.check_box : Icons.check_box_outline_blank,
              onPressed: () {
                viewModel.toggleBackgroundSound();
              },
            ),
          ];
        }, builder: (callback) {
          return SpIconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: callback,
          );
        }),
      ],
    );
  }

  Widget buildSounds(
    BuildContext context,
    SoundType type,
    int index,
  ) {
    List<SoundModel>? sounds = viewModel.soundsMap[type];
    return SliverStickyHeader(
      header: _SoundTypeHeader(context: context, text: type.name.capitalize, type: type),
      sliver: SliverPadding(
        padding: EdgeInsets.only(bottom: index == SoundType.values.length - 1 ? kToolbarHeight * 2 : 0.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              SoundModel sound = sounds![index];
              bool downloaded = viewModel.fileManager.downloaded(sound);
              return _SoundTile(
                sound: sound,
                downloaded: downloaded,
                index: index,
                viewModel: viewModel,
                onTap: () => onSoundPressed(context, downloaded, sound.type, sound),
              );
            },
            childCount: sounds?.length ?? 0,
          ),
        ),
      ),
    );
  }

  Future<void> onSoundPressed(
    BuildContext context,
    bool downloaded,
    SoundType type,
    SoundModel sound,
  ) async {
    UserProvider userProvider = context.read<UserProvider>();
    List<SoundModel> downloadedSounds = await viewModel.fileManager.downloadedSound();
    MiniSoundPlayerProvider provider = context.read<MiniSoundPlayerProvider>();
    if (downloaded) {
      if (provider.currentSound(type)?.fileName != sound.fileName) {
        provider.play(sound);
      } else {
        provider.stop(sound.type);
      }
    } else {
      if (userProvider.purchased(ProductAsType.relexSound) ||
          downloadedSounds.where((element) => element.type == type).isEmpty) {
        String? errorMessage = await viewModel.download(sound);
        provider.load();
        if (errorMessage != null) {
          MessengerService.instance.showSnackBar(errorMessage, success: false);
        }
      } else {
        MessengerService.instance.showSnackBar(
          "Purchase to download more",
          action: SnackBarAction(
            label: "Add-ons",
            onPressed: () {
              Navigator.of(context).pushNamed(SpRouter.addOn.path);
            },
          ),
        );
      }
    }
  }
}
