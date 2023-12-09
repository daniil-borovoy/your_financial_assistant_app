import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:your_financial_assistant_app/src/controllers/settings.dart';
import 'package:your_financial_assistant_app/src/models/message.dart';
import 'package:your_financial_assistant_app/src/models/transaction.dart';
import 'package:your_financial_assistant_app/src/repos/chat_service.dart';
import 'package:your_financial_assistant_app/src/repos/transactions.dart';

class AppBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    final dir = await getApplicationDocumentsDirectory();
    final httpClient = Dio();
    final isar = Isar.openSync(
      [TransactionSchema, ChatMessageSchema],
      directory: dir.path,
    );
    Get.lazyPut<TransactionsRepo>(() => TransactionsRepo(isar: isar));
    Get.lazyPut<ChatService>(
      () => ChatServiceImpl(isar: isar, httpClient: httpClient),
    );
    Get.lazyPut(() => SettingsController());
  }
}
