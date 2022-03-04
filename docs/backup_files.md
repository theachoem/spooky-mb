In our system, we store each story as a json file.

To backup them, we group them by each year & then upload them to cloud storage. It don't have to override previus backup. Store them as change history.

File name should be:
```sh
# year + "_" + createAt toIso8601String + .json
2022_2022-03-05T02:30:57.218875.json
2022_2022-03-05T02:30:57.218875.json
```

Store each year as json which contain all stories:
```dart
{
  'year': instance.year,
  'created_at': instance.createdAt.toIso8601String(),
  'stories': instance.stories.map((e) => e.toJson()).toList(),
}
```

Once it backup, store them as file in backups/ folder
```

```