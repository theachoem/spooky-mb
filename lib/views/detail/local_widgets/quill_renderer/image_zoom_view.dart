// ignore_for_file: implementation_imports

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:spooky/utils/helpers/quill_helper.dart';
import 'package:spooky/widgets/sp_pop_button.dart';

class ImageZoomView extends StatelessWidget {
  static const ValueKey imageHeroKey = ValueKey("ImageZoomView");

  const ImageZoomView({Key? key, required this.imageUrl}) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () => Navigator.of(context).pop(),
      direction: DismissiblePageDismissDirection.multi,
      isFullScreen: false,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: const SpPopButton(),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: PhotoView(
          heroAttributes: const PhotoViewHeroAttributes(tag: imageHeroKey),
          imageProvider: QuillHelper.imageByUrl(imageUrl),
        ),
      ),
    );
  }
}
