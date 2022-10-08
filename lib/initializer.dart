part of 'main.dart';

class _Initializer {
  static Future<void> load() async {
    // core
    await initialFirebase();
    await EasyLocalization.ensureInitialized();
    tz.initializeTimeZones();
    await FileHelper.initialFile();
    await BaseObjectBoxAdapter.initilize();

    // ui
    await Global.instance._initiailize();
    await ThemeProvider.initialize();
    GoogleFontCacheClearer.call();
    await InitialStoryTabService.initialize();
    if (Platform.isFuchsia || Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      await DesktopWindow.setMinWindowSize(const Size(320, 510));
    }

    // notification:
    // wait to make sure localization completed
    Future.delayed(const Duration(seconds: 3)).then((value) {
      NotificationService.initialize();
    });

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
    initialAnalytic();
  }

  static Future<void> initialFirebase() async {
    switch (FlavorConfig.instance.flavor) {
      case Flavor.dev:
      case Flavor.qa:
        await Firebase.initializeApp();
        break;
      case Flavor.production:
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        break;
    }
    FlutterError.onError = (FlutterErrorDetails details) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
  }

  static Future<void> initialAnalytic() async {
    bool supported = await FirebaseAnalytics.instance.isSupported();
    if (supported) {
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      if (!FirebaseAnalytics.instance.app.isAutomaticDataCollectionEnabled) {
        await FirebaseAnalytics.instance.app.setAutomaticDataCollectionEnabled(true);
      }

      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) await FirebaseAnalytics.instance.setUserId(id: uid);
    }
  }
}
