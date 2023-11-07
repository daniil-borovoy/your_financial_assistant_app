import 'package:flutter/material.dart';
import 'package:your_financial_assistant_app/main.dart';
import 'package:your_financial_assistant_app/src/models/transaction.dart';

class TransactionCreationPage extends StatefulWidget {
  const TransactionCreationPage({super.key});

  static create() {
    return MaterialPageRoute(
        builder: (context) => const TransactionCreationPage());
  }

  @override
  State createState() => _TransactionCreationPageState();
}

class _TransactionCreationPageState extends State<TransactionCreationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String title = '';
  double amount = 0.0;
  DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавление транзакции'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Название'),
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
                decoration: InputDecoration(labelText: 'Сумма'),
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
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Now you can create the transaction object with the entered data
                          Transaction newTransaction = Transaction(
                              title: title,
                              amount: amount,
                              date: date ?? DateTime.now());
                          await transactionsRepo.createItem(newTransaction);
                          // You can handle the new transaction as needed (e.g., add it to a list, save to a database, etc.)
                          // Add your logic here
                          Navigator.pop(context,
                              newTransaction); // Close the creation page
                        }
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
}
