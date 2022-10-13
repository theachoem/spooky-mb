# Theme
## Usages
To minimize the access to theme, color and text style, we created `M3TextTheme` & `M3Color`. See usage below:
```dart
// Before
Theme.of(context).textTheme.bodySmall
Theme.of(context).colorScheme.primary
```

```dart
// Now
M3TextTheme.of(context).bodySmall
M3Color.of(context).primary
```

## Extensions
We also include extensions such as [ColorExtension](lib/core/extensions/color_extension.dart) & [ColorSchemeExtension](lib/core/extensions/color_scheme_extension.dart) to make usage of color much more easier & efficiency.

### Usages:
```dart
// Make color 
// darker & lighter
M3Color.of(context).primary.darken(0.1)
M3Color.of(context).primary.lighten(0.2)
```

```dart
// Opacity on color
// base on material 3
M3Color.of(context).primary.m3Opacity.opacity008
M3Color.of(context).primary.m3Opacity.opacity012
M3Color.of(context).primary.m3Opacity.opacity016
```

```dart
// Read only colors from 
// Material 3 on Figma
M3Color.of(context).readOnly.surface1
M3Color.of(context).readOnly.surface2
M3Color.of(context).readOnly.surface3
M3Color.of(context).readOnly.surface4
M3Color.of(context).readOnly.surface5
```