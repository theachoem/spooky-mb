// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    AppStarter.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const AppStarterView());
    },
    InitPickColor.name: (routeData) {
      final args = routeData.argsAs<InitPickColorArgs>();
      return AdaptivePage<dynamic>(
          routeData: routeData,
          child: InitPickColorView(
              key: args.key, showNextButton: args.showNextButton));
    },
    Lock.name: (routeData) {
      final args = routeData.argsAs<LockArgs>();
      return AdaptivePage<dynamic>(
          routeData: routeData,
          child: LockView(key: args.key, flowType: args.flowType));
    },
    Main.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const MainView());
    },
    AddOns.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const AddOnsView());
    },
    Archive.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const ArchiveView());
    },
    BackupsDetail.name: (routeData) {
      final args = routeData.argsAs<BackupsDetailArgs>();
      return AdaptivePage<dynamic>(
          routeData: routeData,
          child: BackupsDetailsView(
              key: args.key,
              destination: args.destination,
              cloudFiles: args.cloudFiles,
              initialCloudFile: args.initialCloudFile));
    },
    BottomNavSetting.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const BottomNavSettingView());
    },
    ChangesHistory.name: (routeData) {
      final args = routeData.argsAs<ChangesHistoryArgs>();
      return AdaptivePage<dynamic>(
          routeData: routeData,
          child: ChangesHistoryView(
              key: args.key,
              story: args.story,
              onRestorePressed: args.onRestorePressed,
              onDeletePressed: args.onDeletePressed));
    },
    CloudStorages.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const CloudStoragesView());
    },
    ContentReader.name: (routeData) {
      final args = routeData.argsAs<ContentReaderArgs>();
      return AdaptivePage<dynamic>(
          routeData: routeData,
          child: ContentReaderView(key: args.key, content: args.content));
    },
    Detail.name: (routeData) {
      final args = routeData.argsAs<DetailArgs>();
      return AdaptivePage<dynamic>(
          routeData: routeData,
          child: DetailView(
              key: args.key,
              initialStory: args.initialStory,
              intialFlow: args.intialFlow));
    },
    DeveloperMode.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const DeveloperModeView());
    },
    Explore.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const ExploreView());
    },
    FontManager.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const FontManagerView());
    },
    Home.name: (routeData) {
      final args = routeData.argsAs<HomeArgs>();
      return AdaptivePage<dynamic>(
          routeData: routeData,
          child: HomeView(
              key: args.key,
              onTabChange: args.onTabChange,
              onYearChange: args.onYearChange,
              onScrollControllerReady: args.onScrollControllerReady));
    },
    ManagePages.name: (routeData) {
      final args = routeData.argsAs<ManagePagesArgs>();
      return AdaptivePage<dynamic>(
          routeData: routeData,
          child: ManagePagesView(key: args.key, content: args.content));
    },
    NicknameCreator.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const NicknameCreatorView());
    },
    NotFound.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const NotFoundView());
    },
    Security.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const SecurityView());
    },
    Setting.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const SettingView());
    },
    SoundList.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const SoundListView());
    },
    StoryPadRestore.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const StoryPadRestoreView());
    },
    ThemeSetting.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const ThemeSettingView());
    },
    User.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const UserView());
    },
    SignIn.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const SignInView());
    },
    SignUp.name: (routeData) {
      return AdaptivePage<dynamic>(
          routeData: routeData, child: const SignUpView());
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(AppStarter.name, path: 'app-starter'),
        RouteConfig(InitPickColor.name, path: 'pick-color'),
        RouteConfig(Lock.name, path: 'lock-view'),
        RouteConfig(Main.name, path: '/', children: [
          RouteConfig(AddOns.name, path: 'add-ons', parent: Main.name),
          RouteConfig(Archive.name, path: 'archive', parent: Main.name),
          RouteConfig(BackupsDetail.name,
              path: 'backups-detail', parent: Main.name),
          RouteConfig(BottomNavSetting.name,
              path: 'bottom-nav-setting', parent: Main.name),
          RouteConfig(ChangesHistory.name,
              path: 'changes-history', parent: Main.name),
          RouteConfig(CloudStorages.name,
              path: 'cloud-storages', parent: Main.name),
          RouteConfig(ContentReader.name,
              path: 'content-reader', parent: Main.name),
          RouteConfig(Detail.name, path: 'detail', parent: Main.name),
          RouteConfig(DeveloperMode.name,
              path: 'developer-mode', parent: Main.name),
          RouteConfig(Explore.name, path: 'explore', parent: Main.name),
          RouteConfig(FontManager.name,
              path: 'font-manager', parent: Main.name),
          RouteConfig(Home.name, path: '', parent: Main.name),
          RouteConfig(ManagePages.name,
              path: 'manage-pages', parent: Main.name),
          RouteConfig(NicknameCreator.name,
              path: 'nickname-creator', parent: Main.name),
          RouteConfig(NotFound.name, path: 'not-found', parent: Main.name),
          RouteConfig(Security.name, path: 'security', parent: Main.name),
          RouteConfig(Setting.name, path: 'setting', parent: Main.name),
          RouteConfig(SoundList.name, path: 'sounds', parent: Main.name),
          RouteConfig(StoryPadRestore.name,
              path: 'storypad-restore', parent: Main.name),
          RouteConfig(ThemeSetting.name,
              path: 'theme-setting', parent: Main.name),
          RouteConfig(User.name, path: 'user', parent: Main.name),
          RouteConfig(User.name, path: 'user', parent: Main.name),
          RouteConfig(SignIn.name, path: 'sign-in', parent: Main.name),
          RouteConfig(SignUp.name, path: 'sign-up', parent: Main.name)
        ])
      ];
}

/// generated route for
/// [AppStarterView]
class AppStarter extends PageRouteInfo<void> {
  const AppStarter() : super(AppStarter.name, path: 'app-starter');

  static const String name = 'AppStarter';
}

/// generated route for
/// [InitPickColorView]
class InitPickColor extends PageRouteInfo<InitPickColorArgs> {
  InitPickColor({Key? key, required bool showNextButton})
      : super(InitPickColor.name,
            path: 'pick-color',
            args: InitPickColorArgs(key: key, showNextButton: showNextButton));

  static const String name = 'InitPickColor';
}

class InitPickColorArgs {
  const InitPickColorArgs({this.key, required this.showNextButton});

  final Key? key;

  final bool showNextButton;

  @override
  String toString() {
    return 'InitPickColorArgs{key: $key, showNextButton: $showNextButton}';
  }
}

/// generated route for
/// [LockView]
class Lock extends PageRouteInfo<LockArgs> {
  Lock({Key? key, required LockFlowType flowType})
      : super(Lock.name,
            path: 'lock-view', args: LockArgs(key: key, flowType: flowType));

  static const String name = 'Lock';
}

class LockArgs {
  const LockArgs({this.key, required this.flowType});

  final Key? key;

  final LockFlowType flowType;

  @override
  String toString() {
    return 'LockArgs{key: $key, flowType: $flowType}';
  }
}

/// generated route for
/// [MainView]
class Main extends PageRouteInfo<void> {
  const Main({List<PageRouteInfo>? children})
      : super(Main.name, path: '/', initialChildren: children);

  static const String name = 'Main';
}

/// generated route for
/// [AddOnsView]
class AddOns extends PageRouteInfo<void> {
  const AddOns() : super(AddOns.name, path: 'add-ons');

  static const String name = 'AddOns';
}

/// generated route for
/// [ArchiveView]
class Archive extends PageRouteInfo<void> {
  const Archive() : super(Archive.name, path: 'archive');

  static const String name = 'Archive';
}

/// generated route for
/// [BackupsDetailsView]
class BackupsDetail extends PageRouteInfo<BackupsDetailArgs> {
  BackupsDetail(
      {Key? key,
      required BaseBackupDestination<BaseCloudProvider> destination,
      required List<CloudFileTuple> cloudFiles,
      required CloudFileModel initialCloudFile})
      : super(BackupsDetail.name,
            path: 'backups-detail',
            args: BackupsDetailArgs(
                key: key,
                destination: destination,
                cloudFiles: cloudFiles,
                initialCloudFile: initialCloudFile));

  static const String name = 'BackupsDetail';
}

class BackupsDetailArgs {
  const BackupsDetailArgs(
      {this.key,
      required this.destination,
      required this.cloudFiles,
      required this.initialCloudFile});

  final Key? key;

  final BaseBackupDestination<BaseCloudProvider> destination;

  final List<CloudFileTuple> cloudFiles;

  final CloudFileModel initialCloudFile;

  @override
  String toString() {
    return 'BackupsDetailArgs{key: $key, destination: $destination, cloudFiles: $cloudFiles, initialCloudFile: $initialCloudFile}';
  }
}

/// generated route for
/// [BottomNavSettingView]
class BottomNavSetting extends PageRouteInfo<void> {
  const BottomNavSetting()
      : super(BottomNavSetting.name, path: 'bottom-nav-setting');

  static const String name = 'BottomNavSetting';
}

/// generated route for
/// [ChangesHistoryView]
class ChangesHistory extends PageRouteInfo<ChangesHistoryArgs> {
  ChangesHistory(
      {Key? key,
      required StoryDbModel story,
      required void Function(StoryContentDbModel) onRestorePressed,
      required Future<StoryDbModel> Function(List<int>) onDeletePressed})
      : super(ChangesHistory.name,
            path: 'changes-history',
            args: ChangesHistoryArgs(
                key: key,
                story: story,
                onRestorePressed: onRestorePressed,
                onDeletePressed: onDeletePressed));

  static const String name = 'ChangesHistory';
}

class ChangesHistoryArgs {
  const ChangesHistoryArgs(
      {this.key,
      required this.story,
      required this.onRestorePressed,
      required this.onDeletePressed});

  final Key? key;

  final StoryDbModel story;

  final void Function(StoryContentDbModel) onRestorePressed;

  final Future<StoryDbModel> Function(List<int>) onDeletePressed;

  @override
  String toString() {
    return 'ChangesHistoryArgs{key: $key, story: $story, onRestorePressed: $onRestorePressed, onDeletePressed: $onDeletePressed}';
  }
}

/// generated route for
/// [CloudStoragesView]
class CloudStorages extends PageRouteInfo<void> {
  const CloudStorages() : super(CloudStorages.name, path: 'cloud-storages');

  static const String name = 'CloudStorages';
}

/// generated route for
/// [ContentReaderView]
class ContentReader extends PageRouteInfo<ContentReaderArgs> {
  ContentReader({Key? key, required StoryContentDbModel content})
      : super(ContentReader.name,
            path: 'content-reader',
            args: ContentReaderArgs(key: key, content: content));

  static const String name = 'ContentReader';
}

class ContentReaderArgs {
  const ContentReaderArgs({this.key, required this.content});

  final Key? key;

  final StoryContentDbModel content;

  @override
  String toString() {
    return 'ContentReaderArgs{key: $key, content: $content}';
  }
}

/// generated route for
/// [DetailView]
class Detail extends PageRouteInfo<DetailArgs> {
  Detail(
      {Key? key,
      required StoryDbModel initialStory,
      required DetailViewFlowType intialFlow})
      : super(Detail.name,
            path: 'detail',
            args: DetailArgs(
                key: key, initialStory: initialStory, intialFlow: intialFlow));

  static const String name = 'Detail';
}

class DetailArgs {
  const DetailArgs(
      {this.key, required this.initialStory, required this.intialFlow});

  final Key? key;

  final StoryDbModel initialStory;

  final DetailViewFlowType intialFlow;

  @override
  String toString() {
    return 'DetailArgs{key: $key, initialStory: $initialStory, intialFlow: $intialFlow}';
  }
}

/// generated route for
/// [DeveloperModeView]
class DeveloperMode extends PageRouteInfo<void> {
  const DeveloperMode() : super(DeveloperMode.name, path: 'developer-mode');

  static const String name = 'DeveloperMode';
}

/// generated route for
/// [ExploreView]
class Explore extends PageRouteInfo<void> {
  const Explore() : super(Explore.name, path: 'explore');

  static const String name = 'Explore';
}

/// generated route for
/// [FontManagerView]
class FontManager extends PageRouteInfo<void> {
  const FontManager() : super(FontManager.name, path: 'font-manager');

  static const String name = 'FontManager';
}

/// generated route for
/// [HomeView]
class Home extends PageRouteInfo<HomeArgs> {
  Home(
      {Key? key,
      required void Function(int) onTabChange,
      required void Function(int) onYearChange,
      required void Function(ScrollController) onScrollControllerReady})
      : super(Home.name,
            path: '',
            args: HomeArgs(
                key: key,
                onTabChange: onTabChange,
                onYearChange: onYearChange,
                onScrollControllerReady: onScrollControllerReady));

  static const String name = 'Home';
}

class HomeArgs {
  const HomeArgs(
      {this.key,
      required this.onTabChange,
      required this.onYearChange,
      required this.onScrollControllerReady});

  final Key? key;

  final void Function(int) onTabChange;

  final void Function(int) onYearChange;

  final void Function(ScrollController) onScrollControllerReady;

  @override
  String toString() {
    return 'HomeArgs{key: $key, onTabChange: $onTabChange, onYearChange: $onYearChange, onScrollControllerReady: $onScrollControllerReady}';
  }
}

/// generated route for
/// [ManagePagesView]
class ManagePages extends PageRouteInfo<ManagePagesArgs> {
  ManagePages({Key? key, required StoryContentDbModel content})
      : super(ManagePages.name,
            path: 'manage-pages',
            args: ManagePagesArgs(key: key, content: content));

  static const String name = 'ManagePages';
}

class ManagePagesArgs {
  const ManagePagesArgs({this.key, required this.content});

  final Key? key;

  final StoryContentDbModel content;

  @override
  String toString() {
    return 'ManagePagesArgs{key: $key, content: $content}';
  }
}

/// generated route for
/// [NicknameCreatorView]
class NicknameCreator extends PageRouteInfo<void> {
  const NicknameCreator()
      : super(NicknameCreator.name, path: 'nickname-creator');

  static const String name = 'NicknameCreator';
}

/// generated route for
/// [NotFoundView]
class NotFound extends PageRouteInfo<void> {
  const NotFound() : super(NotFound.name, path: 'not-found');

  static const String name = 'NotFound';
}

/// generated route for
/// [SecurityView]
class Security extends PageRouteInfo<void> {
  const Security() : super(Security.name, path: 'security');

  static const String name = 'Security';
}

/// generated route for
/// [SettingView]
class Setting extends PageRouteInfo<void> {
  const Setting() : super(Setting.name, path: 'setting');

  static const String name = 'Setting';
}

/// generated route for
/// [SoundListView]
class SoundList extends PageRouteInfo<void> {
  const SoundList() : super(SoundList.name, path: 'sounds');

  static const String name = 'SoundList';
}

/// generated route for
/// [StoryPadRestoreView]
class StoryPadRestore extends PageRouteInfo<void> {
  const StoryPadRestore()
      : super(StoryPadRestore.name, path: 'storypad-restore');

  static const String name = 'StoryPadRestore';
}

/// generated route for
/// [ThemeSettingView]
class ThemeSetting extends PageRouteInfo<void> {
  const ThemeSetting() : super(ThemeSetting.name, path: 'theme-setting');

  static const String name = 'ThemeSetting';
}

/// generated route for
/// [UserView]
class User extends PageRouteInfo<void> {
  const User() : super(User.name, path: 'user');

  static const String name = 'User';
}

/// generated route for
/// [SignInView]
class SignIn extends PageRouteInfo<void> {
  const SignIn() : super(SignIn.name, path: 'sign-in');

  static const String name = 'SignIn';
}

/// generated route for
/// [SignUpView]
class SignUp extends PageRouteInfo<void> {
  const SignUp() : super(SignUp.name, path: 'sign-up');

  static const String name = 'SignUp';
}
