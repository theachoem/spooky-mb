# Path Info

# Story Path

```shell
STORY_PARENT_PATH = "$APP_PATH/year/january/$STORY_ID/"
STORY_PARENT_PATH = "$APP_PATH/year/january/$STORY_ID/info.json"

# all changes
STORY_PARENT_PATH = "$APP_PATH/year/january/$STORY_ID/changes/1641472281663.json"
STORY_PARENT_PATH = "$APP_PATH/year/january/$STORY_ID/changes/1819082939948.json" 
```

1. info.json
```json
{
  "id": "1641472281663",
  "starred": false,
  "feeling": null,
  "title": "This title",
  "plain_text": "This is object\nBold\n\nThis is Italic\n\nRed\n",
  "created_at": "2022-01-06T19:31:21.663771",
  "updated_at": "2022-01-06T19:31:21.663771",
  "document": [
    {
      "insert": "This is object\n"
    },
    {
      "insert": "Bold",
      "attributes": {
        "bold": true
      }
    }
  ]
}
```

2. 1641472281663.json
```json
{
  "id": "1641472281663",
  "title": "This title",
  "created_at": "2022-01-06T19:31:21.663771",
  "plain_text": "This is object\nBold\n\nThis is Italic\n\nRed\n",
  "document": [
    {
      "insert": "This is object\n"
    },
    {
      "insert": "Bold",
      "attributes": {
        "bold": true
      }
    },
  ]
}
```

## Other Info
```dart
static const int monday = 1;
static const int tuesday = 2;
static const int wednesday = 3;
static const int thursday = 4;
static const int friday = 5;
static const int saturday = 6;
static const int sunday = 7;
static const int daysPerWeek = 7;
```

```dart
static const int january = 1;
static const int february = 2;
static const int march = 3;
static const int april = 4;
static const int may = 5;
static const int june = 6;
static const int july = 7;
static const int august = 8;
static const int september = 9;
static const int october = 10;
static const int november = 11;
static const int december = 12;
```