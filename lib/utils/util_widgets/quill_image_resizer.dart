import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class QuillImageResizer extends StatefulWidget {
  const QuillImageResizer({
    required this.imageWidth,
    required this.imageHeight,
    required this.maxWidth,
    required this.maxHeight,
    required this.onImageResize,
    Key? key,
  }) : super(key: key);

  final double? imageWidth;
  final double? imageHeight;
  final double maxWidth;
  final double maxHeight;
  final Function(double, double) onImageResize;

  @override
  QuillImageResizerState createState() => QuillImageResizerState();
}

class QuillImageResizerState extends State<QuillImageResizer> {
  late double _width;
  late double _height;

  @override
  void initState() {
    super.initState();
    _width = widget.imageWidth ?? widget.maxWidth;
    _height = widget.imageHeight ?? widget.maxHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SafeArea(
        child: Wrap(
          children: [
            _widthSlider(),
          ],
        ),
      ),
    );
  }

  Widget _slider(double value, double max, String label, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: Slider(
          value: value,
          max: max,
          min: kToolbarHeight,
          divisions: max.toInt(),
          label: value.toInt().toString(),
          onChanged: (val) {
            setState(() {
              onChanged(val);
              _resizeImage();
            });
          },
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _heightSlider() {
    return _slider(_height, widget.maxHeight, 'Height', (value) {
      _height = value;
    });
  }

  Widget _widthSlider() {
    return _slider(_width, widget.maxWidth, 'Width', (value) {
      _width = value;
    });
  }

  bool _scheduled = false;
  void _resizeImage() {
    if (_scheduled) {
      return;
    }

    _scheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.onImageResize(_width, _height);
      _scheduled = false;
    });
  }
}
