/// https://m3.material.io/styles/motion/easing-and-duration/applying-easing-and-duration

class AnimationDurations {
  static const Duration enterScreenEmphasized = emphasizedDecelerate;
  static const Duration exitScreenEmphasized = emphasizedAccelerate;
  static const Duration beginEndOnScreenEmphasized = emphasized;

  static const Duration enterScreenStandard = standardDecelerate;
  static const Duration exitScreenStandard = standardAccelerate;
  static const Duration beginEndOnScreenStandard = standard;

  static const Duration emphasized = long2;
  static const Duration emphasizedDecelerate = medium4;
  static const Duration emphasizedAccelerate = short4;

  static const Duration standard = medium2;
  static const Duration standardDecelerate = medium1;
  static const Duration standardAccelerate = short4;

  static const Duration emphasizedLong1 = long1;
  static const Duration emphasizedLong2 = long2;
  static const Duration emphasizedLong3 = long3;
  static const Duration emphasizedLong4 = long4;

  static const Duration short1 = Duration(milliseconds: 50);
  static const Duration short2 = Duration(milliseconds: 100);
  static const Duration short3 = Duration(milliseconds: 150);
  static const Duration short4 = Duration(milliseconds: 200);
  static const Duration medium1 = Duration(milliseconds: 250);
  static const Duration medium2 = Duration(milliseconds: 300);
  static const Duration medium3 = Duration(milliseconds: 350);
  static const Duration medium4 = Duration(milliseconds: 400);
  static const Duration long1 = Duration(milliseconds: 450);
  static const Duration long2 = Duration(milliseconds: 500);
  static const Duration long3 = Duration(milliseconds: 550);
  static const Duration long4 = Duration(milliseconds: 600);
  static const Duration extraLong1 = Duration(milliseconds: 700);
  static const Duration extraLong2 = Duration(milliseconds: 800);
  static const Duration extraLong3 = Duration(milliseconds: 900);
  static const Duration extraLong4 = Duration(milliseconds: 1000);
}
