// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottom_nav_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BottomNavItemModel _$BottomNavItemModelFromJson(Map<String, dynamic> json) =>
    BottomNavItemModel(
      router: $enumDecodeNullable(_$SpRouterEnumMap, json['router']),
      selected: json['selected'] as bool?,
    );

Map<String, dynamic> _$BottomNavItemModelToJson(BottomNavItemModel instance) =>
    <String, dynamic>{
      'router': _$SpRouterEnumMap[instance.router],
      'selected': instance.selected,
    };

const _$SpRouterEnumMap = {
  SpRouter.home: 'home',
  SpRouter.restore: 'restore',
  SpRouter.cloudStorage: 'cloudStorage',
  SpRouter.fontManager: 'fontManager',
  SpRouter.lock: 'lock',
  SpRouter.security: 'security',
  SpRouter.themeSetting: 'themeSetting',
  SpRouter.managePages: 'managePages',
  SpRouter.archive: 'archive',
  SpRouter.contentReader: 'contentReader',
  SpRouter.changesHistory: 'changesHistory',
  SpRouter.detail: 'detail',
  SpRouter.main: 'main',
  SpRouter.explore: 'explore',
  SpRouter.appStarter: 'appStarter',
  SpRouter.initPickColor: 'initPickColor',
  SpRouter.nicknameCreator: 'nicknameCreator',
  SpRouter.developerMode: 'developerMode',
  SpRouter.addOn: 'addOn',
  SpRouter.soundList: 'soundList',
  SpRouter.bottomNavSetting: 'bottomNavSetting',
  SpRouter.notFound: 'notFound',
  SpRouter.setting: 'setting',
};
