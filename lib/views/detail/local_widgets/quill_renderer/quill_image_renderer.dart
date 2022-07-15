// ignore_for_file: implementation_imports

import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/src/widgets/embeds/image.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/utils/helpers/quill_image_size_helper.dart';
import 'package:spooky/views/detail/local_widgets/quill_renderer/image_resize_button.dart';
import 'package:spooky/views/detail/local_widgets/quill_renderer/image_zoom_view.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';

class QuillImageRenderer extends StatelessWidget {
  const QuillImageRenderer({
    Key? key,
    required this.node,
    required this.controller,
    required this.readOnly,
  }) : super(key: key);

  final quill.Embed node;
  final quill.QuillController controller;
  final bool readOnly;

  Widget imageByUrl(String imageUrl) {
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

    return const SizedBox.shrink();
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

    final sizeHelper = QuillImageResizeHelper(node: node);
    final size = sizeHelper.fetchSize();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: ConfigConstant.margin2),
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: () => viewImage(context, imageUrl),
        onTap: readOnly ? () => onImageTap(context, imageUrl) : null,
        child: Stack(
          children: [
            SizedBox(
              width: size?.item1,
              child: ClipRRect(
                borderRadius: ConfigConstant.circlarRadius1,
                child: Hero(
                  tag: imageUrl,
                  child: imageByUrl(imageUrl),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: SpCrossFade(
                showFirst: !readOnly,
                secondChild: const SizedBox(width: 48),
                firstChild: ImageResizeButton(
                  controller: controller,
                  size: size,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> onImageTap(BuildContext context, String imageUrl) async {
    List<SheetAction<String>> actions = [
      if (imageUrl.startsWith('http')) ...[
        const SheetAction(
          label: "View on web",
          key: "view-on-web",
          icon: CommunityMaterialIcons.web,
        ),
        const SheetAction(
          label: "Copy link",
          key: "copy-link",
          icon: CommunityMaterialIcons.link,
        ),
      ],
      const SheetAction(
        label: "View",
        key: "view",
        icon: CommunityMaterialIcons.image,
      ),
    ];

    if (actions.length == 1 && actions.first.key == 'view') {
      viewImage(context, imageUrl);
      return;
    }

    String? result = await showModalActionSheet<String>(
      context: context,
      title: "Image",
      actions: actions,
    );

    switch (result) {
      case "copy-link":
        await Clipboard.setData(ClipboardData(text: imageUrl));
        MessengerService.instance.showSnackBar("Copied", showAction: false);
        break;
      case "view-on-web":
        AppHelper.openLinkDialog(imageUrl);
        break;
      case "view":
        // ignore: use_build_context_synchronously
        viewImage(context, imageUrl);
        break;
      default:
    }
  }

  Future<void> viewImage(BuildContext context, String imageUrl) async {
    context.pushTransparentRoute(
      ImageZoomView(imageUrl: imageUrl),
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
