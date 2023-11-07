import 'package:flutter/material.dart';
import 'package:your_financial_assistant_app/src/models/transaction.dart';

class TransactionScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionScreen({super.key, required this.transaction});

  static create(Transaction transaction) => MaterialPageRoute(
      builder: (context) => TransactionScreen(transaction: transaction));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTransactionInfo("Title", transaction.title),
            _buildTransactionInfo(
                "Amount", "\$${transaction.amount.toStringAsFixed(2)}"),
            _buildTransactionInfo("Date", _formattedDate(transaction.date)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  String _formattedDate(DateTime date) {
    return "${_getMonthName(date.month)} ${date.day}, ${date.year}";
  }

  String _getMonthName(int month) {
    const List<String> monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return monthNames[month - 1];
  }
}
