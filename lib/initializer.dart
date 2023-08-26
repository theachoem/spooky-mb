part of 'main.dart';

class _Initializer {
  static Future<void> load({
    FirebaseOptions? firebaseOptions,
  }) async {
    // core
    await initialFirebase(firebaseOptions);
    await EasyLocalization.ensureInitialized();
    tz.initializeTimeZones();
    await FileHelper.initialFile();
    await BaseObjectBoxAdapter.initilize();
    InAppUpdateProvider.instance.load();
    initializeCloudStorages();

    // ui
    await Global.instance._initiailize();
    await ThemeProvider.initialize();
    await StoryConfigStorage.instance.readObject();
    GoogleFontCacheClearer.call();
    await InitialStoryTabService.initialize();
    await StoryTagsService.instance.load();
    if (Platform.isFuchsia || Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      await DesktopWindow.setMinWindowSize(const Size(320, 510));
    }

    // license
    LicenseRegistry.addLicense(() async* {
      final quicksandLicense = await rootBundle.loadString('assets/fonts/Quicksand/OFL.txt');
      final absurdLicense = await rootBundle.loadString('assets/licenses/absurd.txt');
      yield LicenseEntryWithLineBreaks(['Quicksand'], quicksandLicense);
      yield LicenseEntryWithLineBreaks(['Absurd Design'], absurdLicense);
    });

    // debug
    // FlutterError.onError = (details) => DebugErrorException.run(details);

    // analytic
    AnalyticInitializer.initialize();

    // remote config
    RemoteConfigService.instance.initialize();
  }

  // Add other storage to be pre-load here
  static Future<void> initializeCloudStorages() async {
    await GoogleCloudProvider.instance.load();
  }

  static Future<void> initialFirebase(FirebaseOptions? firebaseOptions) async {
    await Firebase.initializeApp(options: firebaseOptions);
    _listenToErrors();
    _listenToNonFlutterErrors();
  }

  static void _listenToErrors() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
  }

  static void _listenToNonFlutterErrors() {
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
