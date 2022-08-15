import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'dart:convert' as convert;
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/utils/helpers/quill_helper.dart';

class StoryPadRestoreViewModel extends BaseViewModel {
  StoryPadRestoreViewModel();
  String? url;
  Map<String, http.Response?> downloadeds = {};
  List<StoryDbModel>? stories;

  Future<void> load() async {
    if (url == null) return;

    String? id;

    try {
      final split = url?.split("/");
      final index = split?.indexWhere((element) => element == 'd');
      id = split?[index! + 1];
      // ignore: empty_catches
    } catch (e) {}

    downloadeds['url'] ??= await http.get(Uri.parse('https://drive.google.com/uc?export=download&id=$id'));
    final db = downloadeds['url']!.body;
    final decrypted = decryptToString(db);
    List json = convert.jsonDecode(decrypted);
    List stories = json[1][1];

    this.stories = await compute(_constructStories, stories);
  }

  String decryptToString(String backup) {
    final key = encrypt.Key.fromUtf8('2020_PRIVATES_KEYS_ENCRYPTS_2020');
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return encrypter.decrypt64(backup, iv: iv);
  }

  Future<void> restore() async {
    for (StoryDbModel element in stories ?? []) {
      StoryDbModel story = element.copyWith(id: element.createdAt.millisecondsSinceEpoch);
      await StoryDatabase.instance.set(body: story);
    }
    MessengerService.instance.showSnackBar(tr("msg.restore.success"));
  }
}

DateTime? _toDate(dynamic paramsDate) {
  try {
    final dateEpoch = int.tryParse("$paramsDate");
    final date = DateTime.fromMillisecondsSinceEpoch(dateEpoch!);
    return date;
    // ignore: empty_catches
  } catch (e) {
    if (kDebugMode) rethrow;
  }
  return null;
}

List<StoryDbModel> _constructStories(List dbStories) {
  List<StoryDbModel> models = [];

  for (final json in dbStories) {
    DateTime? createdAt = _toDate(json['create_on']);
    DateTime? forDate = _toDate(json['for_date']);
    DateTime? updatedAt = _toDate(json['update_on']);

    String? paragraph = json['paragraph'];
    bool starred = json['is_favorite'] != "0";
    String? title = json['title'];
    String? feeling = json['feeling'];

    if (paragraph == null) return [];

    q.Document? document;

    try {
      paragraph = HtmlCharacterEntities.decode(paragraph).replaceAll("▘", "'");
      final quill = convert.jsonDecode(paragraph);
      document = q.Document.fromJson(quill);
      // ignore: empty_catches
    } catch (e) {}

    if (forDate != null && document != null) {
      final validatedCreatedAt = createdAt ?? forDate;

      final content = StoryContentDbModel.create(
        createdAt: validatedCreatedAt,
        id: validatedCreatedAt.millisecondsSinceEpoch,
      ).copyWith(
        title: title,
        plainText: QuillHelper.toPlainText(document.root),
        pages: [
          document.toDelta().toJson(),
        ],
      );

      final story = StoryDbModel.fromDate(forDate).copyWith(
        starred: starred,
        createdAt: createdAt,
        updatedAt: updatedAt,
        feeling: feeling,
        changes: [
          content,
        ],
      );

      models.add(story);
    }
  }

  return models;
}
