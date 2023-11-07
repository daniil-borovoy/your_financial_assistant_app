import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:your_financial_assistant_app/src/models/message.dart';
import 'package:your_financial_assistant_app/src/models/transaction.dart';
import 'package:your_financial_assistant_app/src/repos/chat_service.dart';
import 'package:your_financial_assistant_app/src/repos/transactions.dart';

import 'app.dart';

late TransactionsRepo transactionsRepo;
late ChatService chatService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [TransactionSchema, ChatMessageSchema],
    directory: dir.path,
  );

  // TODO: move to compostion root
  transactionsRepo = TransactionsRepo(isar);
  chatService = ChatService(isar);
  //

  await dotenv.load(fileName: ".env");

  runApp(MaterialApp(
    theme: ThemeData.dark(
      useMaterial3: true,
    ),
    home: const MainNavigationScreen(),
  ));
}
