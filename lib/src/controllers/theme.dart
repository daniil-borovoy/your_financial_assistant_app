// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class ThemeController extends GetxController {
//   static ThemeController get to => Get.find();
//
//   Rx<ThemeMode> themeMode = ThemeMode.light.obs;
//
//   ThemeData get currentTheme =>
//       themeMode.value == ThemeMode.dark ? darkTheme : lightTheme;
//
//   final ThemeData lightTheme = ThemeData(
//     primarySwatch: Colors.lime,
//     visualDensity: VisualDensity.adaptivePlatformDensity,
//   );
//
//   final ThemeData darkTheme = ThemeData(
//     primarySwatch: Colors.indigo,
//     visualDensity: VisualDensity.adaptivePlatformDensity,
//     brightness: Brightness.dark,
//   );
//
//   void toggleTheme() {
//     themeMode.value =
//         themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
//     Get.changeThemeMode(themeMode.value);
//   }
// }
