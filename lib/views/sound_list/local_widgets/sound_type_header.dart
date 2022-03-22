part of sound_list_view;

class _SoundTypeHeader extends StatelessWidget {
  const _SoundTypeHeader({
    Key? key,
    required this.context,
    required this.text,
    required this.type,
  }) : super(key: key);

  final BuildContext context;
  final String text;
  final SoundType type;

  @override
  Widget build(BuildContext context) {
    MiniSoundPlayerProvider provider = context.read<MiniSoundPlayerProvider>();
    AudioPlayer? player = provider.audioPlayers[type]?.player;
    return Material(
      elevation: 1.0,
      child: SpPopupMenuButton(
        smartDx: true,
        dxGetter: (dx) => MediaQuery.of(context).size.width,
        dyGetter: (dy) => dy + kToolbarHeight + 8.0,
        items: (context) {
          double volumn = player?.volume ?? 1.0;
          return List.generate(4, (index) {
            double _volumn = (index + 1) * 25;
            return SpPopMenuItem(
              title: _volumn.toInt().toString(),
              trailingIconData: volumn * 100 == _volumn ? Icons.check : null,
              onPressed: () {
                player?.setVolume(_volumn / 100);
              },
            );
          });
        },
        builder: (callback) {
          return ListTile(
            onTap: callback,
            title: Text(text),
            tileColor: Theme.of(context).appBarTheme.backgroundColor,
            trailing: StreamBuilder<double>(
              stream: player?.volumeStream,
              builder: (context, snapshot) {
                double volumn = player?.volume ?? 1.0;
                IconData iconData;
                if (volumn == 0.0) {
                  iconData = Icons.volume_mute;
                } else if (volumn <= 0.5) {
                  iconData = Icons.volume_down;
                } else {
                  iconData = Icons.volume_up;
                }
                return Icon(iconData);
              },
            ),
          );
        },
      ),
    );
  }
}
