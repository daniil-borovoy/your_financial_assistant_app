import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:your_financial_assistant_app/src/models/transaction.dart';
import 'package:your_financial_assistant_app/src/repos/transactions.dart';

class TransactionCreationPage extends StatefulWidget {
  const TransactionCreationPage({super.key});

  static create() => MaterialPageRoute(
        builder: (context) => const TransactionCreationPage(),
      );

  @override
  State createState() => _TransactionCreationPageState();
}

class _TransactionCreationPageState extends State<TransactionCreationPage> {
  final transactionsRepo = Get.find<TransactionsRepo>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String title = '';
  double amount = 0.0;
  DateTime? date;
  TransactionType transactionType = TransactionType.expense;
  TransactionCategory transactionCategory = TransactionCategory.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавление транзакции'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Название'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста введите название транзакции';
                  }
                  return null;
                },
                onSaved: (value) {
                  title = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Сумма'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста введите сумму';
                  }
                  return null;
                },
                onSaved: (value) {
                  amount = double.parse(value!);
                },
              ),
              Row(
                children: [
                  DropdownButton(
                    items: TransactionType.values
                        .map((e) => DropdownMenuItem(
                              value: e, // Добавьте это
                              child: Text(e.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        transactionType = value!;
                      });
                    },
                    value: transactionType,
                  ),
                ],
              ),
              Row(
                children: [
                  DropdownButton(
                    items: TransactionCategory.values
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        transactionCategory = value!;
                      });
                    },
                    value: transactionCategory,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final navigator = Navigator.of(context);
                        createTransaction(navigator: navigator);
                      },
                      child: const Text('Добавить'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createTransaction({required NavigatorState navigator}) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newTransaction = Transaction()
        ..title = title
        ..amount = amount
        ..category = transactionCategory
        ..type = transactionType
        ..date = date ?? DateTime.now();

      await transactionsRepo.createItem(newTransaction);

      _backToTransactionsScreen(newTransaction, navigator: navigator);
    }
  }

  void _backToTransactionsScreen(
    Transaction createdTransaction, {
    required NavigatorState navigator,
  }) {
    navigator.pop(createdTransaction);
  }
}
