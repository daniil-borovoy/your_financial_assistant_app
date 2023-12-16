import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:your_financial_assistant_app/bindings.dart';
import 'package:your_financial_assistant_app/src/controllers/translations.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await AppBindings().dependencies();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    locale: Get.deviceLocale ?? const Locale('en'),
    translations: Messages(),
    theme: ThemeData(
      primarySwatch: Colors.indigo,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.dark,
    ),
    home: const MainNavigationScreen(),
  ));
}
