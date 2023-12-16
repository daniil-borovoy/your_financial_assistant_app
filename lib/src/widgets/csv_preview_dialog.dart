import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:your_financial_assistant_app/src/repos/transactions.dart';
import 'package:your_financial_assistant_app/src/widgets/csv_import_result.dart';

class CsvPreviewDialog extends StatelessWidget {
  final Future<List<List<dynamic>>?> csvDataFuture;

  const CsvPreviewDialog({super.key, required this.csvDataFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<dynamic>>?>(
      future: csvDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return AlertDialog(
            title: Text('Error'.tr),
            content: Text('An error occurred while loading CSV preview.'.tr),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'.tr),
              ),
            ],
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          return ResultDialog(data: snapshot.data ?? []);
        } else {
          return AlertDialog(
            title: Text('no_data'.tr),
            content: Text('no_data_to_preview'.tr),
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

class ResultDialog extends StatefulWidget {
  final List<List<dynamic>> data;

  const ResultDialog({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _ResultDialogState();
}

class _ResultDialogState extends State<ResultDialog> {
  late Future<bool> _future;
  final TransactionsRepo _transactionsRepo = Get.find();

  @override
  void initState() {
    super.initState();
    _future = validateCSV(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return AlertDialog(
              title: Text('error'.tr),
              content: Text('loading_file_exception'.tr),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'.tr),
                ),
              ],
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            final isValid = snapshot.data!;

            if (isValid) {
              return AlertDialog(
                title: Text('csv_preview'.tr),
                content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: _buildTableColumns(widget.data),
                      rows: _buildTableRows(widget.data),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('cancel'.tr),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);

                      showDialog(
                        context: context,
                        builder: (context) => CsvImportResultModal(
                          importResult: _transactionsRepo
                              .importCSVData(widget.data.sublist(1)),
                        ),
                      );
                    },
                    child: Text('submit'.tr),
                  ),
                ],
              );
            }

            return AlertDialog(
              title: Text('csv_preview'.tr),
              content: SingleChildScrollView(
                child: Text("incorrect_csv_file".tr),
              ),
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
          return AlertDialog(
            title: Text('no_data'.tr),
            content: Text('no_data_to_preview'.tr),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'.tr),
              ),
            ],
          );
        });
  }

  List<DataColumn> _buildTableColumns(List<List<dynamic>> data) {
    // Assuming the first row of CSV contains headers
    List<String> headers = data.isNotEmpty ? List.from(data.first) : [];

    return headers.map((header) => DataColumn(label: Text(header))).toList();
  }

  List<DataRow> _buildTableRows(List<List<dynamic>> data) {
    // Skip the first row as it contains headers
    List<List<dynamic>> rows = data.skip(1).toList();

    return rows.map((row) {
      return DataRow(
        cells: row.map((cell) => DataCell(Text('$cell'))).toList(),
      );
    }).toList();
  }
}

Future<bool> validateCSV(List<List<dynamic>> csvData) async {
  // Ensure there is at least one row in the CSV
  if (csvData.isEmpty) {
    return false;
  }

  // Ensure the header row contains the required columns
  List<String> headers = List.from(csvData.first);
  if (!headers.contains('title') ||
      !headers.contains('amount') ||
      !headers.contains('category') ||
      !headers.contains('type')) {
    return false;
  }

  // Validate each data row
  for (int i = 1; i < csvData.length; i++) {
    List<dynamic> row = csvData[i];

    // Validate 'amount' column (should be int or double)
    if (row.length > headers.indexOf('amount') &&
        !(row[headers.indexOf('amount')] is int ||
            row[headers.indexOf('amount')] is double)) {
      return false;
    }

    // Validate 'type' column (should be 'income' or 'expense')
    if (row.length > headers.indexOf('type') &&
        !(row[headers.indexOf('type')] == 'income' ||
            row[headers.indexOf('type')] == 'expense')) {
      return false;
    }

    // Validate 'category' column (should be one of the specified values)
    if (row.length > headers.indexOf('category') &&
        !(row[headers.indexOf('category')] == 'none' ||
            row[headers.indexOf('category')] == 'groceries' ||
            row[headers.indexOf('category')] == 'food' ||
            row[headers.indexOf('category')] == 'entertainment' ||
            row[headers.indexOf('category')] == 'gas')) {
      return false;
    }
  }

  return true;
}
