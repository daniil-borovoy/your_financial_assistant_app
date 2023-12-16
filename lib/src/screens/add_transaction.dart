import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:your_financial_assistant_app/src/models/transaction.dart';
import 'package:your_financial_assistant_app/src/repos/transactions.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController _dateController = TextEditingController();

  String title = '';
  double amount = 0.0;
  DateTime? date;
  TransactionType transactionType = TransactionType.expense;
  TransactionCategory transactionCategory = TransactionCategory.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('transaction_creation'.tr),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'name'.tr),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please_enter_transaction_name'.tr;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) {
                      title = value;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'amount'.tr),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please_enter_amount'.tr;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    amount = double.parse(value!);
                  },
                ),
                const SizedBox(height: 15),
                _buildDateInput('date'.tr, _dateController),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: DropdownButton(
                    isExpanded: true,
                    items: TransactionType.values
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name.tr),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        transactionType = value!;
                      });
                    },
                    value: transactionType,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    isExpanded: true,
                    items: TransactionCategory.values
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name.tr),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        transactionCategory = value!;
                      });
                    },
                    value: transactionCategory,
                  ),
                ),
                const SizedBox(height: 15),
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
                        child: Text('create'.tr),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

  Widget _buildDateInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () => _selectDate(context),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.calendar_today),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void _backToTransactionsScreen(
    Transaction createdTransaction, {
    required NavigatorState navigator,
  }) {
    navigator.pop(createdTransaction);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    date = picked;
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}
