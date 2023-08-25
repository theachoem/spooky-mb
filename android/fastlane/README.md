fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android push_dev_to_firebase_distribution

```sh
[bundle exec] fastlane android push_dev_to_firebase_distribution
```

Push Development APK to Firebase App Distribution

### android push_staging_to_firebase_distribution

```sh
[bundle exec] fastlane android push_staging_to_firebase_distribution
```

Push Staging APK to Firebase App Distribution

### android push_prod_to_firebase_distribution

```sh
[bundle exec] fastlane android push_prod_to_firebase_distribution
```

Push Production APK to Firebase App Distribution

### android build_apk

```sh
[bundle exec] fastlane android build_apk
```

Build Release APK file

### android push_apk_to_firebase

```sh
[bundle exec] fastlane android push_apk_to_firebase
```

Push APK to Firebase

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
