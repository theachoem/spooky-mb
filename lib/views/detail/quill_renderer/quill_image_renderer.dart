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
import 'package:popover/popover.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/helpers/quill_extensions.dart' as ext;
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/utils/helpers/quill_helper.dart';
import 'package:spooky/utils/helpers/quill_image_size_helper.dart';
import 'package:spooky/views/detail/quill_renderer_helper/image_resize_button.dart';
import 'package:spooky/views/detail/quill_renderer_helper/image_zoom_view.dart';
import 'package:spooky/views/detail/quill_renderer/quill_unsupported_renderer.dart';
import 'package:spooky/widgets/sp_fade_in.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'package:tuple/tuple.dart';

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
    if (ext.isImageBase64(imageUrl)) {
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
        errorWidget: (context, url, error) {
          bool driveImage = url.startsWith('https://drive.google.com/uc?export=download&id=');
          return QuillUnsupportedRenderer(
            message: driveImage ? tr('alert.image_drive_404.message') : "$error\n:$imageUrl",
            buttonLabel: tr('button.show_image_url'),
            onPressed: () async {
              final result = await showOkCancelAlertDialog(
                context: context,
                title: tr('alert.image_source.title'),
                message: url,
                okLabel: tr('button.copy_link'),
              );

              if (result == OkCancelResult.ok) {
                Clipboard.setData(ClipboardData(text: url));
              }
            },
          );
        },
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

    return Wrap(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTap: () => viewImage(context, imageUrl),
          onTap: () => readOnly ? onImageTap(context, imageUrl) : popOver(context, imageUrl, size),
          child: ClipRRect(
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
        ),
      ],
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

    // if (actions.length == 1 && actions.first.key == 'view') {
    //   viewImage(context, imageUrl);
    //   return;
    // }

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

  Future<void> popOver(
    BuildContext context,
    String imageUrl,
    Tuple2<double?, double?>? size,
  ) async {
    if (!QuillHelper.imageExist(imageUrl)) return;

    List<Widget> childrens = [
      ImageResizeButton(
        controller: controller,
        size: size,
      ),
      Builder(builder: (context) {
        return SpIconButton(
          icon: Icon(
            Icons.delete,
            color: M3Color.of(context).error,
          ),
          onPressed: () {
            final offset = quill.getEmbedNode(controller, controller.selection.start).item1;
            final collapsed = TextSelection.collapsed(offset: offset);
            controller.replaceText(offset, 1, '', collapsed);
            Navigator.of(context).pop();
          },
        );
      }),
      Builder(builder: (context) {
        return SpIconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            onImageTap(context, imageUrl);
          },
        );
      }),
    ];

    showPopover(
      context: context,
      backgroundColor: Colors.transparent,
      shadow: [],
      radius: 0,
      contentDyOffset: 2.0,
      transitionDuration: const Duration(milliseconds: 0),
      bodyBuilder: (context) => Container(
        margin: const EdgeInsets.only(left: 12.0),
        decoration: BoxDecoration(
          borderRadius: ConfigConstant.circlarRadius1,
          color: M3Color.of(context).background,
        ),
        child: SpFadeIn(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: childrens,
          ),
        ),
      ),
      direction: PopoverDirection.bottom,
      width: childrens.length <= 2
          ? 48.0 * childrens.length + 8.0 * (childrens.length - 1) + 8
          : 48.0 * childrens.length + 8.0 * (childrens.length - 1),
      height: 48,
      arrowHeight: 4,
      arrowWidth: 8,
      onPop: () {},
    );
  }
}
