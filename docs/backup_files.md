In our system, we store each story as a json file.

To backup them, we group them by each year & then upload them to cloud storage. It don't have to override previus backup. Store them as change history.

File name should be:
```sh
# year + "_" + createAt millisecond since epoch
2020_1646123928000.json
2020_1646123921303.json
2021_1646123921303.json
```

Store each year as json which contain all stories:
```dart
{
  'year': instance.year,
  'created_at': instance.createdAt.toIso8601String(),
  'stories': instance.stories.map((e) => e.toJson()).toList(),
}
```