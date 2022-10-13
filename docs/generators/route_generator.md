# Route Generator
We use [auto_route](https://pub.dev/packages/auto_route) as our routing system as it allow us to:
- Have strongly-typed arguments passing
- Effortless deep-linking 
- It uses code generation to simplify routes setup.

## Adding new route
### 1. Generate a new view
Currently, We use [Flutter MVVM Architecture](https://marketplace.visualstudio.com/items?itemName=madhukesh040011.flutter-mvvm-architecture-generator) VScode extension to generate view.
To create a view:
1. From keyboard, press **Cmd + Shift + p** 
2. Choose: `Flutter Architecture: Create Views`
3. Enter your view name, then It’ll automatically create a folder in your `lib/views/your_view_name/` that contain:

### 2. Add view to router 
Add your page in [lib/core/routes/app_router.dart](lib/core/routes/app_router.dart) as following:
```dart
@MaterialAutoRouter(
  routes: <AutoRoute>[
    ...
    AutoRoute(
      path: 'books',
      page: BooksView,
      meta: {
        'title': 'Books',
      },
    ),
  ]
)
```

### 3. Generate route
From your console, generate them with build_runner:
```
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

## Usage
```dart
AutoRouter.of(context)
context.router

router.push(const BooksRoute())
router.pushNamed('/books')
```

For complex navigator, read more here:
- https://pub.dev/packages/auto_route#navigating-between-screens