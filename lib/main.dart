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
    translations: Messages(),
    theme: ThemeData.dark(),
    home: const MainNavigationScreen(),
  ));
}
