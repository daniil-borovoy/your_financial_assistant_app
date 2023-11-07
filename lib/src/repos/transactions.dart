import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:your_financial_assistant_app/src/models/transaction.dart';
import 'package:your_financial_assistant_app/src/repos/base_crud.dart';

final class TransactionsRepo implements BaseCrudRepo<Transaction> {
  late final Isar _isar;

  TransactionsRepo(this._isar);

  TransactionsRepo._internal();

  static create(Isar isar) async {
    final repo = TransactionsRepo._internal();
    final dir = await getApplicationDocumentsDirectory();
    repo._isar = await Isar.open(
      [TransactionSchema],
      directory: dir.path,
    );
    return repo;
  }

  @override
  Future<List<Transaction>> getItems({int page = 1, int limit = 10}) {
    return _isar.transactions
        .where()
        .offset((page - 1) * limit)
        .limit(limit)
        .findAll();
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
  Future<Transaction> updateItem(Transaction payload) {
    // final item
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteItemById(int id) {
    return _isar.transactions.delete(id);
  }

  @override
  Future<int> createItem(Transaction payload) async {
    return _isar.writeTxn(() => _isar.transactions.put(payload));
  }
}
