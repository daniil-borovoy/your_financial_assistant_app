import 'dart:ui';

import 'package:get/get.dart';

class SettingsController extends GetxController {
  var selectedLanguage = 'en'.obs;

  void changeLanguage(String languageCode) {
    selectedLanguage.value = languageCode;
    Get.updateLocale(Locale(languageCode));
  }
}
