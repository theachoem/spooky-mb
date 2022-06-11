// ignore_for_file: implementation_imports

import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/src/widgets/embeds/image.dart';
import 'package:overscroll_pop/overscroll_pop.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/detail/local_widgets/quill_renderer/image_zoom_view.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';

class QuillImageRenderer extends StatelessWidget {
  const QuillImageRenderer({
    Key? key,
    required this.node,
  }) : super(key: key);

  final quill.Embed node;

  Widget? imageByUrl(String imageUrl) {
    if (isImageBase64(imageUrl)) {
      return Image.memory(
        base64.decode(imageUrl),
        width: null,
        height: null,
      );
    }

    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: null,
        height: null,
      );
    }

    if (File(imageUrl).existsSync()) {
      return Image.file(
        File(imageUrl),
        width: null,
        height: null,
      );
    }

    return null;
  }

  String standardizeImageUrl(String url) {
    if (url.contains('base64')) {
      return url.split(',')[1];
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = standardizeImageUrl(node.value.data);
    return GestureDetector(
      onDoubleTap: () {
        pushDragToPopRoute(
          context: context,
          fullscreenDialog: true,
          barrierDismissible: true,
          barrierColor: Colors.black12,
          child: ImageZoomView(
            scrollToPopOption: ScrollToPopOption.both,
            dragToPopDirection: DragToPopDirection.vertical,
            imageUrl: imageUrl,
          ),
        );
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: ConfigConstant.margin2),
            child: ClipRRect(
              borderRadius: ConfigConstant.circlarRadius1,
              child: imageByUrl(imageUrl),
            ),
          ),
        ],
      ),
    );
  }

  @Deprecated('not yet needed')
  Widget buildMoreVertButton(String imageUrl) {
    return Positioned(
      top: ConfigConstant.margin2 + 4.0,
      right: ConfigConstant.margin0,
      child: SpPopupMenuButton(
        items: (BuildContext context) {
          return [
            SpPopMenuItem(
              leadingIconData: CommunityMaterialIcons.image,
              title: "View",
              onPressed: () {},
            ),
            SpPopMenuItem(
              title: "Open in Google Drive",
              onPressed: () {},
              leadingIconData: CommunityMaterialIcons.google_drive,
            ),
          ];
        },
        builder: (callback) {
          return SpIconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: callback,
          );
        },
      ),
    );
  }
}
