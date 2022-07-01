part of 'main.dart';

class _Initializer {
  static Future<void> load() async {
    // core
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await EasyLocalization.ensureInitialized();
    tz.initializeTimeZones();
    await FileHelper.initialFile();

    await BaseObjectBoxAdapter.initilize();

    // ui
    await Global.instance._initiailize();
    await ThemeProvider.initialize();
    NotificationService.initialize();
    await InitialStoryTabService.initialize();
    if (Platform.isFuchsia || Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      await DesktopWindow.setMinWindowSize(const Size(320, 510));
    }

    // license
    LicenseRegistry.addLicense(() async* {
      final license = await rootBundle.loadString('google_fonts/OFL.txt');
      yield LicenseEntryWithLineBreaks(['google_fonts'], license);
    });

    // debug
    // FlutterError.onError = (details) => DebugErrorException.run(details);
  }
}
