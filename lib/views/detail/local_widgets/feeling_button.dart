import 'package:animated_clipper/animated_clipper.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/models/feeling_model.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/views/detail/local_widgets/feeling_picker.dart';
import 'package:spooky/widgets/sp_floating_popup_button.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'dart:math';

class FeelingButton extends StatefulWidget {
  const FeelingButton({
    Key? key,
    required this.onPicked,
    required this.feeling,
  }) : super(key: key);

  final String? feeling;
  final void Function(String feeling) onPicked;

  @override
  State<FeelingButton> createState() => _FeelingButtonState();
}

class _FeelingButtonState extends State<FeelingButton> {
  late final ConfettiController excitingController;
  late final ConfettiController heartController;
  late final ConfettiController blowingController;

  @override
  void initState() {
    excitingController = ConfettiController(duration: const Duration(seconds: 5));
    heartController = ConfettiController(duration: const Duration(seconds: 5));
    blowingController = ConfettiController(duration: const Duration(seconds: 5));
    super.initState();
  }

  @override
  void dispose() {
    excitingController.dispose();
    heartController.dispose();
    blowingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      blastDirection: pi * 6,
      confettiController: blowingController,
      shouldLoop: false,
      blastDirectionality: BlastDirectionality.directional,
      createParticlePath: (size) => drawHeart(size),
      colors: M3Color.dayColorsOf(context).values.toList(),
      child: ConfettiWidget(
        confettiController: heartController,
        shouldLoop: false,
        blastDirectionality: BlastDirectionality.explosive,
        createParticlePath: (size) => drawHeart(size),
        colors: [M3Color.dayColorsOf(context)[DateTime.sunday]!],
        child: ConfettiWidget(
          confettiController: excitingController,
          shouldLoop: false,
          blastDirectionality: BlastDirectionality.explosive,
          createParticlePath: (size) => drawStar(size),
          colors: M3Color.dayColorsOf(context).values.toList(),
          child: buildButton(),
        ),
      ),
    );
  }

  Widget buildButton() {
    return SpFloatingPopUpButton(
      cacheFloatingSize: 300,
      bottomToTop: false,
      dyGetter: (dy) => dy + 64,
      pathBuilder: PathBuilders.slideDown,
      floatBuilder: (void Function() callback) {
        return FeelingPicker(
          feeling: widget.feeling,
          onPicked: (feeling) {
            widget.onPicked(feeling);
            callback();

            switch (feeling) {
              case "excited":
                excitingController.play();
                Future.delayed(const Duration(seconds: 1)).then((value) {
                  excitingController.stop();
                });
                break;
              case "in_love":
                heartController.play();
                Future.delayed(const Duration(seconds: 1)).then((value) {
                  heartController.stop();
                });
                break;
              case "blowing":
                blowingController.play();
                Future.delayed(const Duration(seconds: 1)).then((value) {
                  blowingController.stop();
                });
                break;
              default:
            }
          },
        );
      },
      builder: (callback) {
        return SpIconButton(
          icon: FeelingModel.feelingsMap[widget.feeling]?.image64.image(width: ConfigConstant.iconSize2) ??
              const Icon(Icons.add_reaction_sharp),
          backgroundColor: M3Color.of(context).readOnly.surface1,
          onPressed: callback,
        );
      },
    );
  }

  Path drawHeart(Size size) {
    double width = size.width;
    double height = size.height;

    Path path = Path();
    path.moveTo(0.5 * width, height * 0.35);
    path.cubicTo(0.2 * width, height * 0.1, -0.25 * width, height * 0.6, 0.5 * width, height);
    path.moveTo(0.5 * width, height * 0.35);
    path.cubicTo(0.8 * width, height * 0.1, 1.25 * width, height * 0.6, 0.5 * width, height);

    return path;
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step), halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
