# Documentation
## Installation
Spooky is developed using the latest version of Flutter:

- Flutter: 3.3.4 - see [current version](.fvm/fvm_config.json)
- Ruby: 3.1.2 - for IOS development - See [current version](.ruby-version).


If you have a different version on your machine, consider:
- [Install rbenv](https://github.com/rbenv/rbenv) or alternate for Ruby.
- [Install FVM](https://soksereyphon8.medium.com/flutter-version-management-3c318c4ff97d) for Flutter.
```s
fvm flutter pub get
fvm flutter run
```

## Code Generation
### Build runner
We use [build_runner](https://pub.dev/packages/build_runner) to generate model, route, etc. To generate, run following command:
```s
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

See more:
- Adding & generating a MODEL: [model_generator.md](./docs/generators/model_generator.md)
- Adding & generating new ROUTE: [route_generator.md](./docs/generators/route_generator.md)

### Asset generation
We use [flutter_gen](https://pub.dev/packages/flutter_gen) to get rid of all String-based APIs. **Motivation:**
```dart
// String-based practice - bad practice
Image.asset('assets/images/profile.jpeg');

// Better practice
Image.asset(Assets.images.profile.path);
```
See more:
- How to setup & generate: [assets_generator.md](./docs/generators/assets_generator.md)

## User Interface
Spooky is powered by `Material 3` design system. Basic usages of theme:
```dart
M3TextTheme.of(context).bodySmall
M3Color.of(context).primary
```

For more advance usages, theme usage: [theme.md](./docs/ui/theme.md)

## Semantic Versioning

We use [Semantic Versioning](https://semver.org/) to numbering each release.
Example. the current version is `1`.`0`.`0`. Given the version number `MAJOR`.`MINOR`.`PATCH` then increment the:

- MAJOR version when we make incompatible API changes. → version = `2`.`0`.`0`
- MINOR version when we add functionality in a backward-compatible manner. → version = `1`.`1`.`0`
- PATCH version when we make backward-compatible bug fixes. → version = `1`.`0`.`1`


Use the following commands to release them to the remote repository:

```
git tag 1.0.6
git push 1.0.6
```

## Extending Documentation
For better managing our documents, we move most part to ["docs/"](./docs) directory. 
In case you want to add more documentation, consider:
1. Create new file `docs/document_category/your_doc.md`
2. Link them in main `README.md`