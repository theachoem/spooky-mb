part of sound_list_view;

class _SoundListMobile extends StatelessWidget {
  final SoundListViewModel viewModel;
  const _SoundListMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    List<SoundType> types = SoundType.values.reversed.toList();
    return Scaffold(
      appBar: buildAppBar(context),
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
      leading: ModalRoute.of(context)?.canPop == true ? const SpPopButton() : null,
      title: const SpAppBarTitle(fallbackRouter: SpRouter.soundList),
      flexibleSpace: const FlexibleSpaceBar(
        background: MiniplayerAppBarBackground(),
      ),
      actions: [
        const NotificationPermissionButton(),
        Consumer<MiniSoundPlayerProvider>(
          child: SpIconButton(
            tooltip: tr("button.stop"),
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
        if (ModalRoute.of(context)?.canPop == true)
          Consumer<MiniSoundPlayerProvider>(
            child: SpIconButton(
              tooltip: tr("button.listen_with_mini_player"),
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
          final provider = context.read<BottomNavItemsProvider>();
          bool hasSoundInNavBar = provider.tabs?.contains(SpRouter.soundList) == true;
          return [
            SpPopMenuItem(
              title: tr("tile.play_in_background.title"),
              leadingIconData: viewModel.playSoundInBackground ? Icons.check_box : Icons.check_box_outline_blank,
              onPressed: () async {
                // future value
                NotificationProvider provider = context.read<NotificationProvider>();

                if (!provider.isAllow) {
                  await provider.requestPermission(context);
                }

                if (provider.isAllow) {
                  viewModel.toggleBackgroundSound();
                }
              },
            ),
            SpPopMenuItem(
              title: tr("tile.display_on_navigation_bar"),
              leadingIconData: hasSoundInNavBar ? Icons.check_box : Icons.check_box_outline_blank,
              trailingIconData: Icons.arrow_right,
              onPressed: () {
                Navigator.of(context).pushNamed(SpRouter.bottomNavSetting.path);
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
      header: SpFadeIn(child: _SoundTypeHeader(context: context, text: type.name.capitalize, type: type)),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            SoundModel sound = sounds![index];
            bool downloaded = viewModel.fileManager.downloaded(sound);
            return SpFadeIn(
              child: _SoundTile(
                sound: sound,
                downloaded: downloaded,
                index: index,
                viewModel: viewModel,
                onTap: () => onSoundPressed(context, downloaded, sound.type, sound),
              ),
            );
          },
          childCount: sounds?.length ?? 0,
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
    InAppPurchaseProvider inAppPurchaseProvider = context.read<InAppPurchaseProvider>();
    await viewModel.fileManager.downloadedSound().then((downloadedSounds) async {
      MiniSoundPlayerProvider provider = context.read<MiniSoundPlayerProvider>();
      if (downloaded) {
        if (provider.currentSound(type)?.fileName != sound.fileName) {
          provider.play(sound);
        } else {
          provider.stop(sound.type);
        }
      } else {
        bool purchased = inAppPurchaseProvider.purchased(ProductAsType.relexSound);
        if (!purchased && viewModel.downloadingSoundsNotifier.value.length > 2) {
          alertRequiredPurchase(context);
          return;
        }

        if (purchased || downloadedSounds.where((element) => element.type == type).isEmpty) {
          String? errorMessage = await viewModel.download(sound);
          provider.load();
          if (errorMessage != null) {
            MessengerService.instance.showSnackBar(errorMessage, success: false);
          }
        } else {
          alertRequiredPurchase(context);
        }
      }
    });
  }

  void alertRequiredPurchase(BuildContext context) {
    MessengerService.instance.showSnackBar(
      tr("alert.purchase_to_download_more.title"),
      action: (color) => SnackBarAction(
        label: tr("button.add_ons"),
        textColor: color,
        onPressed: () {
          Navigator.of(context).pushNamed(SpRouter.addOn.path);
        },
      ),
    );
  }
}
