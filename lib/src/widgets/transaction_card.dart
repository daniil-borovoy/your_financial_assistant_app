import 'package:flutter/material.dart';
import 'package:your_financial_assistant_app/src/models/transaction.dart';
import 'package:your_financial_assistant_app/src/pages/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  final Function() onDeleted;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: const Icon(Icons.attach_money),
        title: Text(transaction.title),
        subtitle: Text(transaction.date.toString()),
        trailing: Text('\$${transaction.amount.toStringAsFixed(2)}'),
        onTap: () => _onTransactionCardTap(context, transaction),
      ),
    );
  }

  _onTransactionCardTap(BuildContext context, Transaction transaction) {
    Navigator.of(context)
        .push(TransactionScreen.create(transaction))
        .then((deleted) {
      if (deleted == true) {
        onDeleted();
      }
    });
  }
}
