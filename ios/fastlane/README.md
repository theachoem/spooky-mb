fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios push_dev_to_testflight

```sh
[bundle exec] fastlane ios push_dev_to_testflight
```

Push Development to Test Flight

### ios push_staging_to_testflight

```sh
[bundle exec] fastlane ios push_staging_to_testflight
```

Push Staging to Test Flight

### ios push_production_to_testflight

```sh
[bundle exec] fastlane ios push_production_to_testflight
```

Push Production to Test Flight

### ios build_xcarchive

```sh
[bundle exec] fastlane ios build_xcarchive
```

Build Flutter to .xcarchive

### ios codesign_xcarchive

```sh
[bundle exec] fastlane ios codesign_xcarchive
```

Codesign xcarchive

### ios xcarchive_to_ipa

```sh
[bundle exec] fastlane ios xcarchive_to_ipa
```

Build xcarchive to .ipa

### ios push_to_testflight

```sh
[bundle exec] fastlane ios push_to_testflight
```

Upload .ipa To TestFlight

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
