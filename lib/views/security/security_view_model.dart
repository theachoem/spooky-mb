import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/security/helpers/security_question_list_model.dart';
import 'package:spooky/core/security/helpers/security_question_model.dart';
import 'package:spooky/core/security/security_service.dart';
import 'package:spooky/core/storages/local_storages/security/lock_life_circle_duration_storage.dart';
import 'package:spooky/core/storages/local_storages/security/security_questions_storage.dart';
import 'package:spooky/core/types/lock_type.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:spooky/core/base/base_view_model.dart';

class SecurityViewModel extends BaseViewModel with WidgetsBindingObserver {
  final SecurityService service = SecurityService();
  final LockLifeCircleDurationStorage lockLifeCircleDurationStorage = LockLifeCircleDurationStorage();
  final SecurityQuestionsStorage securityQuestionsStorage = SecurityQuestionsStorage();

  late final ValueNotifier<LockType?> lockedTypeNotifier;
  late final ValueNotifier<int> lockLifeCircleDurationNotifier;
  late final ValueNotifier<SecurityQuestionListModel> securityQuestionNotifier;

  SecurityViewModel() {
    lockedTypeNotifier = ValueNotifier(null);
    securityQuestionNotifier = ValueNotifier(SecurityQuestionListModel([]));
    lockLifeCircleDurationNotifier = ValueNotifier(AppConstant.lockLifeDefaultCircleDuration.inSeconds);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      load();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> load() async {
    securityQuestionsStorage.readObject().then((value) {
      securityQuestionNotifier.value = value ?? initialQuestions();
    });
    service.lockInfo.getLock().then((e) {
      lockedTypeNotifier.value = e?.type;
    });
    lockLifeCircleDurationStorage.read().then((value) {
      if (value == null) return;
      lockLifeCircleDurationNotifier.value = value;
    });
  }

  SecurityQuestionListModel initialQuestions() {
    return SecurityQuestionListModel([
      SecurityQuestionModel(
        question: tr("question.name_of_primary_best_friend"),
        key: 'best_friend',
        answer: null,
      ),
      SecurityQuestionModel(
        question: tr("question.favorite_movie"),
        key: 'favorite_movie',
        answer: null,
      )
    ]);
  }

  Future<void> setAnswer(SecurityQuestionModel question) async {
    SecurityQuestionListModel questions = securityQuestionNotifier.value;
    List<SecurityQuestionModel> items = questions.items ?? [];

    // clear if no answer & custom question
    if (question.key.startsWith("custom") && question.answer == null) {
      items.removeWhere((element) => question.key == element.key);
    } else {
      bool alreadySet = items.map((e) => e.key).contains(question.key) == true;
      if (alreadySet) {
        int index = items.indexWhere((e) => e.key == question.key);
        items[index] = question;
      } else {
        items.add(question);
      }
    }

    securityQuestionNotifier.value = SecurityQuestionListModel(items);
    securityQuestionsStorage.writeObject(securityQuestionNotifier.value);
  }

  Future<void> clearAnswer(SecurityQuestionModel question) async {}

  @override
  void dispose() {
    lockedTypeNotifier.dispose();
    lockLifeCircleDurationNotifier.dispose();
    securityQuestionNotifier.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void setLockLifeCircleDuration(int? second) {
    lockLifeCircleDurationStorage.write(second);
    load();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        // user may close app to add finger print,
        // we call to refresh it,
        SecurityService.initialize().then((value) {
          notifyListeners();
        });
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }
}
