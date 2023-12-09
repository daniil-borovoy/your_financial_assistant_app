import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:your_financial_assistant_app/src/repos/transactions.dart';
import 'package:your_financial_assistant_app/src/widgets/csv_preview_dialog.dart';

class TransactionsCSVImportScreen extends StatelessWidget {
  final TransactionsRepo _transactionsRepo = Get.find();

  TransactionsCSVImportScreen({super.key});

  static create() =>
      MaterialPageRoute(builder: (context) => TransactionsCSVImportScreen());

  // Add a TextEditingController to store the selected delimiter
  final TextEditingController _delimiterController = TextEditingController();

  // List of common delimiters with labels
  final List<Map<String, String>> commonDelimiters = [
    {'label': 'Comma (,)', 'value': ','},
    {'label': 'Semicolon (;)', 'value': ';'},
    {'label': 'Pipe (|)', 'value': '|'},
    {'label': 'Tab (\t)', 'value': '\t'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV Import'.tr),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose a CSV file to import transactions:',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () async {
                  // Retrieve the selected delimiter
                  String delimiter = _delimiterController.text;
                  final dataFuture =
                      _transactionsRepo.getCSVData(delimiter: delimiter);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CsvPreviewDialog(csvDataFuture: dataFuture);
                    },
                  );
                  // Add logic to choose a CSV file
                  // You can use packages like file_picker or image_picker for file selection
                },
                child: const Text('Choose File'),
              ),
              const SizedBox(height: 20.0),
              const Divider(),
              const SizedBox(height: 20.0),
              Text("Import setup", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20.0),
              // Add a DropdownButtonFormField to select the delimiter
              const Text("Choose column delimiter",
                  style: TextStyle(fontSize: 16)),
              DropdownButtonFormField<Map<String, String>>(
                value: commonDelimiters.first, // Default delimiter
                onChanged: (value) {
                  _delimiterController.text = value!['value']!;
                },
                items: commonDelimiters
                    .map((delimiter) => DropdownMenuItem<Map<String, String>>(
                          value: delimiter,
                          child: Text(delimiter['label']!),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20.0),
              const Divider(),
              const SizedBox(height: 20.0),
              CSVImportTips(),
            ],
          ),
        ),
      ),
    );
  }
}

class CSVImportTips extends StatelessWidget {
  const CSVImportTips({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CSV Import Tips 💡',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 20.0),
        // ------------
        TextTipWithTitle(
          title: 'Column Order:',
          description:
              'Make sure your CSV file has columns in the correct order: title, amount, date, category, type.',
        ),
        SizedBox(height: 20.0),
        TextTipWithTitle(
          title: 'Data Rows:',
          description:
              'Enter your transaction data in rows below the column headers.',
        ),
        SizedBox(height: 20.0),
        TextTipWithTitle(
          title: 'Date Format:',
          description:
              "'Use a consistent date format for the 'date' column (e.g., DD.MM.YYYY).'",
        ),
        SizedBox(height: 20.0),
        TextTipWithTitle(
          title: 'Missing Values:',
          description:
              "Leave cells empty for optional fields (e.g., category in the last row).",
        ),
        SizedBox(height: 20.0),
        TextTipWithTitle(
          title: 'Delimiter:',
          description:
              "Select the correct delimiter (comma, semicolon, pipe, or tab) before importing.",
        ),
        SizedBox(height: 20.0),
        // -----------
        Text(
            "Ensure your CSV file aligns with this structure for a smooth import process. If in doubt, refer to this example or consult the documentation."),
        SizedBox(height: 20.0),
      ],
    );
  }
}

class TextTipWithTitle extends StatelessWidget {
  final String title;
  final String description;

  const TextTipWithTitle(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 20.0),
        Text(
          description,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
