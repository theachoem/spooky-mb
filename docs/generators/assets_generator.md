# Asset Generator
We use [flutter_gen](https://pub.dev/packages/flutter_gen) to get rid of all String-based APIs. To make things easier, `flutter_gen` will read all assets & fonts from [pubspec.yaml](../../pubspec.yaml) and generate them into classes. 

## Usage

```dart
// String-based - bad practice
Image.asset('assets/images/profile.jpeg');
TextStyle(fontFamily: "Quicksand")

// Use this instead
Image.asset(Assets.images.profile.path);
Assets.images.profile.image()
TextStyle(fontFamily: FontFamily.quicksand)
```

## Setup
For on macOS, Linux, and Windows.
```bash
# Installing
dart pub global activate flutter_gen

# To make sure it's installed
fluttergen
```
- It also has installation via brew, For more installation: https://pub.dev/packages/flutter_gen

## Generate
To generate, add needed assets or fonts in [pubspec.yaml](../../pubspec.yaml), then run `fluttergen` on your console.

```yaml
flutter:
  ...
  assets:
    - assets/illustrations
    - assets/images

  # also work with fonts
  fonts:
    - family: Schyler
      fonts:
        - asset: fonts/Schyler-Regular.ttf
        - asset: fonts/Schyler-Italic.ttf
          style: italic
```

```bash
# From console
fluttergen
```