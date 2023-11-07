import 'package:isar/isar.dart';

part 'transaction.g.dart';

@collection
class Transaction {
  final Id? id = Isar.autoIncrement;

  final String title;
  final double amount;
  final DateTime date;

  const Transaction({
    required this.title,
    required this.amount,
    required this.date,
  });
}
