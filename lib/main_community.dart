import 'firebase_options/community.dart' deferred as community;
import 'main.dart' deferred as source;

Future<void> main() async {
  await community.loadLibrary();
  await source.loadLibrary();

  return source.main(
    firebaseOptions: community.DefaultFirebaseOptions.currentPlatform,
  );
}
