import 'package:get/get.dart';

class SupportedLocales {
  const SupportedLocales._();

  static get ruRU => 'ru_RU';

  static get enUS => 'en_US';
}

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        SupportedLocales.enUS: {
          'Home': 'Home',
          'welcome': 'Welcome!',
          'CSV Import': 'CSV Import',
        },
        SupportedLocales.ruRU: {
          'Home': 'Главная',
          'welcome': 'Добро пожаловать!',
          'CSV Import': 'CSV импорт'
        },
      };
}
