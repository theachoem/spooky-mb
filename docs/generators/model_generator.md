# Model Generator
We use Json Serializable [ https://flutter.dev/docs/development/data-and-backend/json#code-generation ] package build tool to generate model from Json to Class object.

Required packages:
- copy_with_extension: ^4.0.2
- json_serializable: ^6.2.0
- json_annotation: ^4.5.0

## Adding new model
### 1. Create model file,
To create model, create a file with data as following with needed field.

> lib/core/models/story_model.dart
```dart
import 'package:spooky/core/base/base_model.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story_model.g.dart';

@CopyWith()
@JsonSerializable()
class StoryModel extends BaseModel {
  final int? id;
  final String? name;
  ...

  StoryModel({
    this.id,
    this.name,
    ...
  });

  @override
  Map<String, dynamic> toJson() => _$StoryModelToJson(this);
  factory StoryModel.fromJson(Map<String, dynamic> json) => _$StoryModelFromJson(json);
}
```
### 2. Generating
Run following command to generate `*.g.dart` file for your model. Additionally, It will also generate other models `.g.dart` in case they have changes.
```s
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

## To be notice
### Default case
We use snack case by default, so we might no longer use `@JsonKey(name: "recommendation_id")`.
```dart
// From this
@JsonKey(name: "recommendation_id")
String? recommendationId;

// To just this:
String? recommendationId;
```

### Customization
We can customize & override current behaviour in [build.yaml](../../build.yaml).