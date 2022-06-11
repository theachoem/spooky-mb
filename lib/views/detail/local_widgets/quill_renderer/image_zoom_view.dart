// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:overscroll_pop/overscroll_pop.dart';
import 'package:photo_view/photo_view.dart';
import 'package:spooky/utils/helpers/quill_helper.dart';
import 'package:spooky/widgets/sp_pop_button.dart';

class ImageZoomView extends StatelessWidget {
  const ImageZoomView({
    Key? key,
    required this.imageUrl,
    required this.scrollToPopOption,
    this.dragToPopDirection,
  }) : super(key: key);

  final ScrollToPopOption scrollToPopOption;
  final DragToPopDirection? dragToPopDirection;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: const SpPopButton(),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: OverscrollPop(
        scrollToPopOption: scrollToPopOption,
        dragToPopDirection: dragToPopDirection,
        child: PhotoView(
          imageProvider: QuillHelper.imageByUrl(imageUrl),
        ),
      ),
    );
  }
}
