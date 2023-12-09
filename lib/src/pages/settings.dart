import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:your_financial_assistant_app/src/controllers/settings.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  static create() => MaterialPageRoute(builder: (context) => SettingsPage());

  final SettingsController _settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Language:',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            DropdownButton<String>(
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
                  child: Text('Russian'),
                ),
                // Add more languages as needed
              ],
            ),
          ],
        ),
      ),
    );
  }
}
