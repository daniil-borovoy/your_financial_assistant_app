import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:isar/isar.dart';
import 'package:your_financial_assistant_app/src/models/transaction.dart';
import 'package:your_financial_assistant_app/src/repos/base_crud.dart';

final class TransactionsRepo implements BaseCrudRepo<Transaction> {
  final Isar _isar;

  const TransactionsRepo({required Isar isar}) : _isar = isar;

  @override
  Future<List<Transaction>> getItems({int page = 1, int limit = 10}) {
    return _isar.transactions
        .where()
        .offset((page - 1) * limit)
        .limit(limit)
        .findAll();
  }

  Future<int> countAll() {
    return _isar.transactions.count();
  }

  @override
  Future<Transaction> getItemById(int id) async {
    final item = await _isar.transactions.get(id);
    if (item == null) {
      throw Exception("Item not found");
    }
    return item;
  }

  @override
  Future<Transaction> updateItem(Transaction payload) async {
    final id = await _isar.writeTxn(() => _isar.transactions.put(payload));
    final transaction = await _isar.transactions.get(id);
    if (transaction == null) {
      throw Exception("Unbelievable...");
    }
    return transaction;
  }

  @override
  Future<bool> deleteItemById(int? id) async {
    if (id == null) {
      return false;
    }
    try {
      await _isar.writeTxn(() => _isar.transactions.delete(id));
      return true;
    } catch (err) {
      return false;
    }
  }

  @override
  Future<int> createItem(Transaction payload) {
    return _isar.writeTxn(() => _isar.transactions.put(payload));
  }

  Future<List<List<dynamic>>?> getCSVData({required String delimiter}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.isNotEmpty) {
        File file = File(result.files.first.path!);
        String csvString = await file.readAsString();

        List<List<dynamic>> csvData = const CsvToListConverter().convert(
          csvString,
          // textDelimiter: delimiter,
          eol: "\n",
        );

        return csvData;
      }
      return null;
    } catch (error) {
      // Handle errors during CSV import
      print("CSV Import Error: $error");
      return null;
    }
  }

  Future<bool> importCSVData(List<List<dynamic>> data) async {
    try {
      await _isar.writeTxn(() async {
        for (final el in data) {
          final type = TransactionType.values.firstWhere(
              (element) => element.name == el[4],
              orElse: () => TransactionType.expense);
          final category = TransactionCategory.values.firstWhere(
            (element) => element.name == el[3],
            orElse: () => TransactionCategory.none,
          );
          await _isar.transactions.put(
            Transaction()
              ..title = el[0]
              ..amount = el[1] is int ? (el[1] as int).toDouble() : el[1]
              ..date = DateTime.tryParse(el[2]) ?? DateTime.now()
              ..type = type
              ..category = category,
          );
        }
      });
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<double> getTotalAmount() async {
    final transactions = await _isar.transactions.where().findAll();
    double totalAmount =
        transactions.fold(0, (acc, transaction) => acc + transaction.amount);
    return totalAmount;
  }

  Future<double> getAverageAmount() async {
    final transactions = await _isar.transactions.where().findAll();
    if (transactions.isEmpty) return 0;

    double totalAmount =
        transactions.fold(0, (acc, transaction) => acc + transaction.amount);
    return totalAmount / transactions.length;
  }

  Future<Map<String, double>> getMonthlyStatistics() async {
    final transactions = await _isar.transactions.where().findAll();
    Map<String, double> monthlyStatistics = {};

    for (var transaction in transactions) {
      String monthYear = transaction.date
          .toLocal()
          .toString()
          .substring(0, 7); // Формат YYYY-MM
      monthlyStatistics.putIfAbsent(monthYear, () => 0);
      if (monthlyStatistics[monthYear] != null) {
        monthlyStatistics[monthYear] =
            transaction.amount + (monthlyStatistics[monthYear] ?? 0);
      }
    }

    return monthlyStatistics;
  }
}
