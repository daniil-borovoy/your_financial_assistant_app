import 'package:isar/isar.dart';

part 'transaction.g.dart';

@collection
class Transaction {
  Id? id = Isar.autoIncrement;
  late String title;
  late double amount;
  late DateTime date;
  @Enumerated(EnumType.name)
  late TransactionType type;
  @Enumerated(EnumType.name)
  late TransactionCategory category;
}

enum TransactionType {
  income,
  expense,
}

enum TransactionCategory {
  none,
  groceries,
  food,
  entertainment,
  gas,
}
