// ignore_for_file: implementation_imports

import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/utils/helpers/quill_helper.dart';
import 'package:spooky/utils/helpers/quill_image_size_helper.dart';
import 'package:spooky/views/detail/quill_renderer_helper/image_resize_button.dart';
import 'package:spooky/views/detail/quill_renderer_helper/image_zoom_view.dart';
import 'package:spooky/views/detail/quill_renderer/quill_unsupported_renderer.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';

class QuillImageRenderer extends quill.EmbedBuilder {
  @override
  String get key => quill.BlockEmbed.imageType;

  @override
  Widget build(BuildContext context, quill.QuillController controller, quill.Embed node, bool readOnly) {
    return _QuillImageRenderer(
      node: node,
      controller: controller,
      readOnly: readOnly,
    );
  }
}

class _QuillImageRenderer extends StatelessWidget {
  const _QuillImageRenderer({
    Key? key,
    required this.node,
    required this.controller,
    required this.readOnly,
  }) : super(key: key);

  final quill.Embed node;
  final quill.QuillController controller;
  final bool readOnly;

  Widget imageByUrl(
    String imageUrl, {
    required double? width,
    required BuildContext context,
  }) {
    if (isImageBase64(imageUrl)) {
      return Image.memory(
        base64.decode(imageUrl),
        width: width,
        height: null,
      );
    }

    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: null,
      );
    }

    if (File(imageUrl).existsSync()) {
      return Image.file(
        File(imageUrl),
        width: width,
        height: null,
      );
    }

    return SpTapEffect(
      onTap: () {
        showOkAlertDialog(
          context: context,
          title: tr("alert.image_source.title"),
          message: imageUrl,
          okLabel: tr("button.ok"),
        );
      },
      child: QuillUnsupportedRenderer(
        message: tr("msg.invalid_image_source"),
      ),
    );
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

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTap: () => viewImage(context, imageUrl),
      onTap: readOnly ? () => onImageTap(context, imageUrl) : null,
      child: Stack(
        fit: StackFit.loose,
        children: [
          ClipRRect(
            borderRadius: ConfigConstant.circlarRadius1,
            child: Hero(
              tag: imageUrl,
              child: imageByUrl(
                imageUrl,
                width: size?.item1,
                context: context,
              ),
            ),
          ),
          if (QuillHelper.imageExist(imageUrl))
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
    );
  }

  Future<void> onImageTap(BuildContext context, String imageUrl) async {
    List<SheetAction<String>> actions = [
      if (imageUrl.startsWith('http')) ...[
        SheetAction(
          label: tr("button.view_on_web"),
          key: "view-on-web",
          icon: CommunityMaterialIcons.web,
        ),
        SheetAction(
          label: tr("button.copy_link"),
          key: "copy-link",
          icon: CommunityMaterialIcons.link,
        ),
      ],
      SheetAction(
        label: tr("button.view"),
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
      title: tr("alert.image.title"),
      actions: actions,
      cancelLabel: tr("button.cancel"),
    );

    switch (result) {
      case "copy-link":
        await Clipboard.setData(ClipboardData(text: imageUrl));
        MessengerService.instance.showSnackBar(tr("msg.copied"), showAction: false);
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
}
