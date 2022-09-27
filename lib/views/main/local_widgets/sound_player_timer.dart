part of 'mini_sound_player.dart';

class SoundPlayerTimer extends StatefulWidget {
  const SoundPlayerTimer({
    Key? key,
    required this.shouldShowBottomNavNotifier,
  }) : super(key: key);

  final ValueNotifier<bool> shouldShowBottomNavNotifier;

  @override
  State<SoundPlayerTimer> createState() => _SoundPlayerTimerState();
}

class _SoundPlayerTimerState extends State<SoundPlayerTimer> {
  late final CountdownTimerController controller;
  int? _minute;
  int get minute => _minute ?? 30;

  @override
  void initState() {
    controller = buildInitializer();
    super.initState();
    context.read<MiniSoundPlayerProvider>().addListener(() {
      if (currentlyPlaying) {
        if (!controller.isRunning) {
          setMinute(minute);
        }
      }
    });
  }

  CountdownTimerController buildInitializer() {
    return CountdownTimerController(
      endTime: endTime,
      onEnd: () {
        if (minute == 0) return;
        if (!currentlyPlaying) return;

        for (SoundType type in SoundType.values) {
          context.read<MiniSoundPlayerProvider>().pause(type);
        }

        MessengerService.instance.showSnackBar(
          tr("alert.sound_pause_scheduled.title"),
          action: (color) {
            return SnackBarAction(
              label: tr("button.play"),
              textColor: color,
              onPressed: () {
                context.read<MiniSoundPlayerProvider>().togglePlayPause();
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void setMinute(int minute) {
    setState(() {
      _minute = minute == 0 ? null : minute;
      controller.endTime = endTime;
      if (currentlyPlaying) controller.start();
    });
  }

  bool get currentlyPlaying {
    if (mounted) {
      return context.read<MiniSoundPlayerProvider>().currentlyPlaying;
    } else {
      return false;
    }
  }

  int get endTime {
    return DateTime.now().millisecondsSinceEpoch + 1000 * minute * 60;
  }

  @override
  Widget build(BuildContext context) {
    return MiniPlayerBottomPaddingBuilder(
      shouldShowBottomNavNotifier: widget.shouldShowBottomNavNotifier,
      child: buildChild(context),
      builder: (BuildContext context, double offset, double bottomHeight, Widget? child) {
        return Opacity(
          opacity: bottomHeight,
          child: SpTapEffect(
            child: child!,
            onTap: () {
              if (bottomHeight <= 0.5) return;
              SpDatePicker.showMinutePicker(context, controller.currentRemainingTime?.min ?? minute).then((value) {
                int? minute = value?.minute;
                if (minute != null) {
                  setMinute(minute);
                }
              });
            },
          ),
        );
      },
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ConfigConstant.margin1,
        vertical: ConfigConstant.margin0 / 2,
      ),
      decoration: BoxDecoration(
        color: M3Color.of(context).surface.withOpacity(0.7),
        borderRadius: ConfigConstant.circlarRadius2,
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer,
            size: ConfigConstant.iconSize1,
            color: M3Color.of(context).secondary,
          ),
          ConfigConstant.sizedBoxW0,
          buildTimer(),
        ],
      ),
    );
  }

  Widget buildTimer() {
    return CountdownTimer(
      controller: controller,
      widgetBuilder: (context, countdown) {
        return Text(
          countdown?.sec == null
              ? tr("msg.break_time.mn", args: [minute.toString()])
              : [
                  if (countdown?.min != null) tr("time.mn", args: [countdown?.min.toString() ?? ""]),
                  tr("time.sec", args: [countdown?.sec.toString() ?? ""])
                ].join(" "),
          style: M3TextTheme.of(context).labelSmall?.copyWith(color: M3Color.of(context).secondary),
        );
      },
    );
  }
}
