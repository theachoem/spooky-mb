import 'package:spooky/gen/assets.gen.dart';

// No translation for now
String tr(String text) {
  return text;
}

class FeelingModel {
  final String value;
  final String translation;
  final AssetGenImage image64;

  FeelingModel({
    required this.value,
    required this.translation,
    required this.image64,
  });

  static Map<String, FeelingModel> feelingsMap = {
    "beaming": FeelingModel(
      value: "beaming",
      translation: tr("feeling.beaming"),
      image64: Assets.emoji64.beamingFaceWithSmilingEyes64x641395554,
    ),
    "worry": FeelingModel(
      value: "worry",
      translation: tr("feeling.worry"),
      image64: Assets.emoji64.confoundedFace64x641395561,
    ),
    "confused": FeelingModel(
      value: "confused",
      translation: tr("feeling.confused"),
      image64: Assets.emoji64.confusedFace64x641395584,
    ),
    "crying": FeelingModel(
      value: "crying",
      translation: tr("feeling.crying"),
      image64: Assets.emoji64.cryingFace64x641395579,
    ),
    "disappointed": FeelingModel(
      value: "disappointed",
      translation: tr("feeling.disappointed"),
      image64: Assets.emoji64.disappointedFace64x641395587,
    ),
    "dizzy": FeelingModel(
      value: "dizzy",
      translation: tr("feeling.dizzy"),
      image64: Assets.emoji64.dizzyFace64x641395573,
    ),
    "downcast": FeelingModel(
      value: "downcast",
      translation: tr("feeling.downcast"),
      image64: Assets.emoji64.downcastFaceWithSweat64x641395586,
    ),
    "drooling": FeelingModel(
      value: "drooling",
      translation: tr("feeling.drooling"),
      image64: Assets.emoji64.droolingFace64x641395566,
    ),
    "expressionless": FeelingModel(
      value: "expressionless",
      translation: tr("feeling.expressionless"),
      image64: Assets.emoji64.expressionlessFace64x641395580,
    ),
    "blowing": FeelingModel(
      value: "blowing",
      translation: tr("feeling.blowing"),
      image64: Assets.emoji64.faceBlowingAKiss64x641395556,
    ),
    "savoring_food": FeelingModel(
      value: "savoring_food",
      translation: tr("feeling.savoring_food"),
      image64: Assets.emoji64.faceSavoringFood64x641395567,
    ),
    "vomiting": FeelingModel(
      value: "vomiting",
      translation: tr("feeling.vomiting"),
      image64: Assets.emoji64.faceVomiting64x641395569,
    ),
    "head_bandage": FeelingModel(
      value: "head_bandage",
      translation: tr("feeling.head_bandage"),
      image64: Assets.emoji64.faceWithHeadBandage64x641395563,
    ),
    "medical_mask": FeelingModel(
      value: "medical_mask",
      translation: tr("feeling.medical_mask"),
      image64: Assets.emoji64.faceWithMedicalMask64x641395570,
    ),
    "monocle": FeelingModel(
      value: "monocle",
      translation: tr("feeling.monocle"),
      image64: Assets.emoji64.faceWithMonocle64x641395562,
    ),
    "wow": FeelingModel(
      value: "wow",
      translation: tr("feeling.wow"),
      image64: Assets.emoji64.faceWithOpenMouth64x641395578,
    ),
    "mistrust": FeelingModel(
      value: "mistrust",
      translation: tr("feeling.mistrust"),
      image64: Assets.emoji64.faceWithRaisedEyebrow64x641395571,
    ),
    "rolling_eyes": FeelingModel(
      value: "rolling_eyes",
      translation: tr("feeling.rolling_eyes"),
      image64: Assets.emoji64.faceWithRollingEyes64x641395546,
    ),
    "serious": FeelingModel(
      value: "serious",
      translation: tr("feeling.serious"),
      image64: Assets.emoji64.faceWithSymbolsOnMouth64x641395550,
    ),
    "really_funny": FeelingModel(
      value: "really_funny",
      translation: tr("feeling.really_funny"),
      image64: Assets.emoji64.faceWithTearsOfJoy64x641395560,
    ),
    "cuteness": FeelingModel(
      value: "cuteness",
      translation: tr("feeling.cuteness"),
      image64: Assets.emoji64.faceWithTongue64x641395588,
    ),
    "speechlessness": FeelingModel(
      value: "speechlessness",
      translation: tr("feeling.speechlessness"),
      image64: Assets.emoji64.faceWithoutMouth64x641395577,
    ),
    "fearful": FeelingModel(
      value: "fearful",
      translation: tr("feeling.fearful"),
      image64: Assets.emoji64.fearfulFace64x641395553,
    ),
    "flushed": FeelingModel(
      value: "flushed",
      translation: tr("feeling.flushed"),
      image64: Assets.emoji64.flushedFace64x641395564,
    ),
    "nervousness": FeelingModel(
      value: "nervousness",
      translation: tr("feeling.nervousness"),
      image64: Assets.emoji64.grimacingFace64x641395576,
    ),
    "cheerfulness": FeelingModel(
      value: "cheerfulness",
      translation: tr("feeling.cheerfulness"),
      image64: Assets.emoji64.grinningFace64x641395591,
    ),
    "grinning_sweat": FeelingModel(
      value: "grinning_sweat",
      translation: tr("feeling.grinning_sweat"),
      image64: Assets.emoji64.grinningFaceWithSmilingEyes64x641395548,
    ),
    "smiling_broadly": FeelingModel(
      value: "smiling_broadly",
      translation: tr("feeling.smiling_broadly"),
      image64: Assets.emoji64.grinningFaceWithSweat64x641395555,
    ),
    "laughter": FeelingModel(
      value: "laughter",
      translation: tr("feeling.laughter"),
      image64: Assets.emoji64.grinningSquintingFace64x641395574,
    ),
    "loudly_crying": FeelingModel(
      value: "loudly_crying",
      translation: tr("feeling.loudly_crying"),
      image64: Assets.emoji64.loudlyCryingFace64x641395592,
    ),
    "getting_rich": FeelingModel(
      value: "getting_rich",
      translation: tr("feeling.getting_rich"),
      image64: Assets.emoji64.moneyMouthFace64x641395557,
    ),
    "nauseated": FeelingModel(
      value: "nauseated",
      translation: tr("feeling.nauseated"),
      image64: Assets.emoji64.nauseatedFace64x641395559,
    ),
    "nerd": FeelingModel(
      value: "nerd",
      translation: tr("feeling.nerd"),
      image64: Assets.emoji64.nerdFace64x641395568,
    ),
    "neutral": FeelingModel(
      value: "neutral",
      translation: tr("feeling.neutral"),
      image64: Assets.emoji64.neutralFace64x641395585,
    ),
    "pouting": FeelingModel(
      value: "pouting",
      translation: tr("feeling.pouting"),
      image64: Assets.emoji64.poutingFace64x641395575,
    ),
    "sleeping": FeelingModel(
      value: "sleeping",
      translation: tr("feeling.sleeping"),
      image64: Assets.emoji64.sleepingFace64x641395590,
    ),
    "slightly_smiling": FeelingModel(
      value: "slightly_smiling",
      translation: tr("feeling.slightly_smiling"),
      image64: Assets.emoji64.slightlySmilingFace64x641395552,
    ),
    "smiling_halo": FeelingModel(
      value: "smiling_halo",
      translation: tr("feeling.smiling_halo"),
      image64: Assets.emoji64.smilingFaceWithHalo64x641395582,
    ),
    "in_love": FeelingModel(
      value: "in_love",
      translation: tr("feeling.in_love"),
      image64: Assets.emoji64.smilingFaceWithHeartEyes64x641395589,
    ),
    "lovely": FeelingModel(
      value: "lovely",
      translation: tr("feeling.lovely"),
      image64: Assets.emoji64.smilingFaceWithHearts64x641395545,
    ),
    "devil": FeelingModel(
      value: "devil",
      translation: tr("feeling.devil"),
      image64: Assets.emoji64.smilingFaceWithHorns64x641395558,
    ),
    "positive_feelings": FeelingModel(
      value: "positive_feelings",
      translation: tr("feeling.positive_feelings"),
      image64: Assets.emoji64.smilingFaceWithSmilingEyes64x641395594,
    ),
    "something_cool": FeelingModel(
      value: "something_cool",
      translation: tr("feeling.something_cool"),
      image64: Assets.emoji64.smilingFaceWithSunglasses64x641395549,
    ),
    "suggestive_smile": FeelingModel(
      value: "suggestive_smile",
      translation: tr("feeling.suggestive_smile"),
      image64: Assets.emoji64.smirkingFace64x641395593,
    ),
    "annoy_someone": FeelingModel(
      value: "annoy_someone",
      translation: tr("feeling.annoy_someone"),
      image64: Assets.emoji64.squintingFaceWithTongue64x641395581,
    ),
    "excited": FeelingModel(
      value: "excited",
      translation: tr("feeling.excited"),
      image64: Assets.emoji64.starStruck64x641395565,
    ),
    "tired": FeelingModel(
      value: "tired",
      translation: tr("feeling.tired"),
      image64: Assets.emoji64.tiredFace64x641395547,
    ),
    "crazy": FeelingModel(
      value: "crazy",
      translation: tr("feeling.crazy"),
      image64: Assets.emoji64.winkingFace64x641395551,
    ),
    "winking": FeelingModel(
      value: "winking",
      translation: tr("feeling.winking"),
      image64: Assets.emoji64.winkingFaceWithTongue64x641395583,
    ),
    "zany": FeelingModel(
      value: "zany",
      translation: tr("feeling.zany"),
      image64: Assets.emoji64.zanyFace64x641395572,
    ),
  };
}
