import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CsvImportResultModal extends StatelessWidget {
  final Future<bool> importResult;

  const CsvImportResultModal({super.key, required this.importResult});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: importResult,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError || !snapshot.data!) {
          // Show an error message
          return AlertDialog(
            title: Text('Error'.tr),
            content: Text('An error occurred during CSV import.'.tr),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'.tr),
              ),
            ],
          );
        } else {
          // Show a success message
          return AlertDialog(
            title: Text('success'.tr),
            content: Text('csv_import_successful'.tr),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'.tr),
              ),
            ],
          );
        }
      },
    );
  }
}
