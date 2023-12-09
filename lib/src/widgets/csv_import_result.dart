import 'package:flutter/material.dart';

class CsvImportResultModal extends StatelessWidget {
  final Future<bool> importResult;

  CsvImportResultModal({Key? key, required this.importResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: importResult,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError || !snapshot.data!) {
          // Show an error message
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred during CSV import.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        } else {
          // Show a success message
          return AlertDialog(
            title: Text('Success'),
            content: Text('CSV import successful!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        }
      },
    );
  }
}
