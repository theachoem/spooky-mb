```s
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

```s
flutterfire configure
```

package androidx.multidex does not exist.
```s
flutter run --multidex
```

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