import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:your_financial_assistant_app/src/models/transaction.dart';
import 'package:your_financial_assistant_app/src/repos/transactions.dart';

class TransactionScreen extends StatefulWidget {
  final Transaction transaction;
  final TransactionsRepo _transactionsRepo = Get.find();

  TransactionScreen({super.key, required this.transaction});

  static create(Transaction transaction) => MaterialPageRoute(
      builder: (context) => TransactionScreen(transaction: transaction));

  @override
  State createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  late TransactionType transactionType;
  late TransactionCategory transactionCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.transaction.title);
    _amountController =
        TextEditingController(text: widget.transaction.amount.toString());
    _dateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(widget.transaction.date));
    transactionType = widget.transaction.type;
    transactionCategory = widget.transaction.category;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: widget.transaction.date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;
    if (picked != null && picked != widget.transaction.date) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  final navigator = Navigator.of(context);
                  return AlertDialog(
                    title: const Text("Delete transaction"),
                    content: const Text("Are you sure?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          widget._transactionsRepo
                              .deleteItemById(widget.transaction.id)
                              .then((value) {
                            navigator.pop();
                            navigator.pop(true);
                          });
                        },
                        child: Text("Submit"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEditableTransactionInfo("Title", _titleController),
              _buildNumberInput("Amount", _amountController),
              _buildDateInput("Date", _dateController),
              const SizedBox(height: 10),
              _buildCategoryInput(),
              const SizedBox(height: 10),
              _buildTypeInput(),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => _onSavePressed(Navigator.of(context)),
                      child: const Text("Save"),
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

  Widget _buildEditableTransactionInfo(
      String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        TextField(
          controller: controller,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildNumberInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDateInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
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

  _buildCategoryInput() {
    return DropdownButton(
      isExpanded: true,
      elevation: 10,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
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
    );
  }

  _buildTypeInput() {
    return DropdownButton(
      isExpanded: true,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
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
    );
  }

  _onSavePressed(NavigatorState navigatorState) async {
    final Transaction payload = widget.transaction
      ..title = _titleController.text
      ..amount = double.parse(_amountController.text)
      ..category = transactionCategory
      ..type = transactionType
      ..date = DateTime.parse(_dateController.text);
    await widget._transactionsRepo.updateItem(payload);
    navigatorState.pop(true);
  }
}
