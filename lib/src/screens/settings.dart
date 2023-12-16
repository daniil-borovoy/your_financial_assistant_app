import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:your_financial_assistant_app/src/controllers/settings.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  static create() => MaterialPageRoute(builder: (context) => SettingsScreen());

  final SettingsController _settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'language'.tr,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            DropdownButton<String>(
              isExpanded: true,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              value: _settingsController.selectedLanguage.value,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _settingsController.changeLanguage(newValue);
                }
              },
              items: const [
                DropdownMenuItem<String>(
                  value: 'en',
                  child: Text('English'),
                ),
                DropdownMenuItem<String>(
                  value: 'ru',
                  child: Text('Русский (Russian)'),
                ),
                // Add more languages as needed
              ],
            ),
            const SizedBox(height: 10),
            // const DarkModeSwitch(),
          ],
        ),
      ),
    );
  }
}

// class DarkModeSwitch extends StatefulWidget {
//   const DarkModeSwitch({super.key});
//
//   @override
//   State<StatefulWidget> createState() => _DarkModeSwitch();
// }
//
// class _DarkModeSwitch extends State<DarkModeSwitch> {
//   bool _isDarkMode = Get.isDarkMode;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text('enable_dark_mode'.tr, style: const TextStyle(fontSize: 16)),
//         Switch(
//           value: _isDarkMode,
//           onChanged: (value) {
//             setState(() {
//               ThemeController.to.toggleTheme();
//               _isDarkMode = !_isDarkMode;
//             });
//           },
//         ),
//       ],
//     );
//   }
// }
