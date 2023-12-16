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
    {'label': 'comma_delimiter'.tr, 'value': ','},
    {'label': 'semicolon_delimiter'.tr, 'value': ';'},
    {'label': 'pipe_delimiter'.tr, 'value': '|'},
    {'label': 'tab_delimiter'.tr, 'value': '\t'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('csv_import'.tr),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'csv_import_description'.tr,
                style: const TextStyle(fontSize: 18.0),
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
                child: Text('choose_file'.tr),
              ),
              const SizedBox(height: 20.0),
              const Divider(),
              const SizedBox(height: 20.0),
              Text('import_setup'.tr, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20.0),
              // Add a DropdownButtonFormField to select the delimiter
              Text(
                'choose_column_delimiter'.tr,
                style: const TextStyle(fontSize: 16),
              ),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'csv_tips'.tr,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 20.0),
        // ------------
        TextTipWithTitle(
          title: 'column_order_tip'.tr,
          description: 'column_order_tip_description'.tr,
        ),
        const SizedBox(height: 20.0),
        TextTipWithTitle(
          title: 'data_rows_tip'.tr,
          description: 'data_rows_tip_description'.tr,
        ),
        const SizedBox(height: 20.0),
        TextTipWithTitle(
          title: 'date_format_tip'.tr,
          description: 'date_format_tip_description'.tr,
        ),
        const SizedBox(height: 20.0),
        TextTipWithTitle(
          title: 'missing_values_tip'.tr,
          description: 'missing_values_tip_description'.tr,
        ),
        const SizedBox(height: 20.0),
        TextTipWithTitle(
          title: 'delimiter_tip'.tr,
          description: 'delimiter_tip_description'.tr,
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}

class TextTipWithTitle extends StatelessWidget {
  final String title;
  final String description;

  const TextTipWithTitle({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 20.0),
        Text(
          description,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
