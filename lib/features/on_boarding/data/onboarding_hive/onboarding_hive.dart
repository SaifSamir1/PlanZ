
import 'package:hive/hive.dart';

class OnboardingHive {
  static const String onboardingBox = 'onboardingBox';
  static const String onboardingValue = 'onboardingSeen';

  static final OnboardingHive _instance = OnboardingHive._internal();

  OnboardingHive._internal();

  factory OnboardingHive() {
    return _instance;
  }

  /// فتح صندوق Hive
  Future<void> openHiveBox() async {
    await Hive.openBox<bool>(onboardingBox);
  }

  /// تخزين حالة الـ Onboarding
  void storeOnboardingValue(bool value) {
    final box = Hive.box<bool>(onboardingBox);
    box.put(onboardingValue, value);
  }

  /// التحقق مما إذا كانت شاشة الـ Onboarding قد شوهدت
  bool isOnboardingSeen() {
    final box = Hive.box<bool>(onboardingBox);
    return box.get(onboardingValue, defaultValue: false) ?? false;
  }
}
