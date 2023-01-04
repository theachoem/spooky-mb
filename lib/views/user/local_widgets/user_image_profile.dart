import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';

class UserImageProfile extends StatelessWidget {
  late final String? profileUrl;
  final User currentUser;
  final ValueNotifier<double> scrollOffsetNotifier;

  UserImageProfile({
    Key? key,
    required this.scrollOffsetNotifier,
    required this.currentUser,
  }) : super(key: key) {
    profileUrl = maximizeImage(currentUser.photoURL);
  }

  String? maximizeImage(String? imageUrl) {
    if (imageUrl == null) return null;
    String lowQuality = "s96-c";
    String highQuality = "s0";
    return imageUrl.replaceAll(lowQuality, highQuality);
  }

  final double avatarSize = 72;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    bool tablet = screenSize.width > screenSize.height;

    return LayoutBuilder(builder: (context, constraint) {
      final width = constraint.maxWidth;
      return ValueListenableBuilder(
        valueListenable: scrollOffsetNotifier,
        builder: (context, double offset, child) {
          final bool isCollapsed = tablet || offset > 200;
          final avatarSize = !isCollapsed ? width : this.avatarSize;
          final padding = !isCollapsed ? EdgeInsets.zero : const EdgeInsets.all(16);
          return AnimatedContainer(
            duration: ConfigConstant.duration,
            curve: Curves.easeOutQuart,
            width: width,
            height: tablet ? kToolbarHeight + 24 * 2 : width,
            padding: padding,
            alignment: Alignment.bottomLeft,
            color: M3Color.of(context).background,
            child: AnimatedOpacity(
              duration: ConfigConstant.fadeDuration,
              curve: Curves.decelerate,
              opacity: offset < 350 ? 1 : 0,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  buildPhoto(avatarSize, isCollapsed),
                  buildProfileInfoTile(isCollapsed, context),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget buildProfileInfoTile(bool isCollapsed, BuildContext context) {
    return AnimatedContainer(
      duration: ConfigConstant.duration,
      width: double.infinity,
      curve: Curves.easeOutQuart,
      height: 72,
      margin: EdgeInsets.only(left: !isCollapsed ? 0 : avatarSize + 16),
      decoration: BoxDecoration(
        borderRadius: !isCollapsed ? BorderRadius.zero : ConfigConstant.circlarRadius2,
        color: M3Color.of(context).primary,
      ),
      child: SpPopupMenuButton(
        dxGetter: (dx) => MediaQuery.of(context).size.width,
        dyGetter: (dy) => dy + kToolbarHeight + 24.0,
        items: (context) {
          String id = currentUser.uid;
          return [
            SpPopMenuItem(
              title: tr("tile.identity.title"),
              subtitle: id,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: id));
              },
            ),
            if (currentUser.metadata.creationTime != null)
              SpPopMenuItem(
                title: tr("tile.created_at.title"),
                subtitle: DateFormatHelper.dateTimeFormat().format(currentUser.metadata.creationTime!),
              ),
            if (currentUser.metadata.lastSignInTime != null)
              SpPopMenuItem(
                title: tr("tile.last_sign_in.title"),
                subtitle: DateFormatHelper.dateTimeFormat().format(currentUser.metadata.lastSignInTime!),
              ),
          ];
        },
        builder: (callback) {
          return ListTile(
            onTap: callback,
            title: Text(
              currentUser.displayName ?? "",
              style: TextStyle(color: M3Color.of(context).onPrimary),
            ),
            subtitle: Text(
              currentUser.email ?? currentUser.uid,
              style: TextStyle(color: M3Color.of(context).onPrimary),
            ),
            trailing: Icon(
              Icons.info,
              color: M3Color.of(context).onPrimary,
            ),
          );
        },
      ),
    );
  }

  Widget buildPhoto(double avatarSize, bool isCollapsed) {
    bool hasPhoto = profileUrl != null;
    return AnimatedContainer(
      duration: ConfigConstant.duration,
      curve: Curves.easeOutQuart,
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          !isCollapsed ? 0 : avatarSize,
        ),
        image: hasPhoto
            ? DecorationImage(
                image: CachedNetworkImageProvider(isCollapsed ? currentUser.photoURL! : profileUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: !hasPhoto
          ? const Icon(
              Icons.person,
              size: ConfigConstant.iconSize5,
            )
          : null,
    );
  }
}
