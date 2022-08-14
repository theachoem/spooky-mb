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
keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore | openssl sha1 -binary | openssl base64
```

Set var in info plish. eg. facebook client token. Not work yet, TODO..
```s
xcodebuild build FACEBOOK_CLIENT_TOKEN=53abd38937fd92ae45ef347396245d9d -project ios/Runner.xcodeproj -target Runner -sdk iphonesimulator
```

Flavor:

https://medium.com/flutter-community/flutter-ready-to-go-e59873f9d7de
```s
fvm flutter run -t lib/main_dev.dart –-flavor dev
fvm flutter build apk --release -t lib/main_dev.dart –-flavor dev 
fvm flutter build appbundle --release -t lib/main_production.dart –-flavor production 
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