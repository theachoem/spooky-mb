> Deprecated!
> See [./docs.md](./docs.md) for orgainized version.

# Quick documentations

Execute all bulid runners
```s
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

Setup Firebase
```s
flutterfire configure
```

package androidx.multidex does not exist.
```s
flutter run --multidex
```

Check android signing report
```s
./gradlew signingReport
```

Generate facebook hash:
```s
keytool -exportcert -alias androiddebugkey -keystore keystore.jks | openssl sha1 -binary | openssl base64
```

Set var in info plish. eg. facebook client token. Not work yet, TODO..
```s
xcodebuild build FACEBOOK_CLIENT_TOKEN=53abd38937fd92ae45ef347396245d9d -project ios/Runner.xcodeproj -target Runner -sdk iphonesimulator
```

Flavor:

https://medium.com/flutter-community/flutter-ready-to-go-e59873f9d7de
```s
fvm flutter run –-flavor dev -t lib/main_dev.dart
fvm flutter build apk --release –-flavor dev  -t lib/main_dev.dart
fvm flutter build appbundle --release –-flavor production -t lib/main_production.dart
```

Fastlan (in ios/):
```s
# invoke certificate
fastlane match nuke

# certificate & git
fastlane certificates
fastlane match init
fastlane match development
fastlane match appstore

fastlane release
```

In case you got `invalid binary`, you have to invoke key & reinit:
```s
fastlane match nuke development
fastlane match nuke distribution

fastlane certificates
fastlane release
```

Log when app crash android:
```s
adb logcat
```

dlopen failed: library "libflutter.so":
```
ndk {
  abiFilters 'x86', 'x86_64', 'armeabi', 'armeabi-v7a', 'mips', 'mips64', 'arm64-v8a'
}
```

Update gradle version:
```
cd android
./gradlew wrapper --gradle-version=7.3
```

References:
https://developer.android.com/about/versions/13/features/app-languages#known-issues