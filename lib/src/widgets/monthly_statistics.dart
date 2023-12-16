import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:your_financial_assistant_app/src/repos/transactions.dart';

class TransactionStatisticsWidget extends StatelessWidget {
  final TransactionsRepo _transactionsRepo = Get.find();

  TransactionStatisticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 30),
        Text(
          'transaction_statistics'.tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        StatisticCard(
          title: 'total_amount'.tr,
          value: _transactionsRepo.getTotalAmount(),
        ),
        StatisticCard(
          title: 'average_amount'.tr,
          value: _transactionsRepo.getAverageAmount(),
        ),
      ],
    );
  }
}

class StatisticCard extends StatelessWidget {
  final String title;
  final Future<double> value;

  const StatisticCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 30),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: value,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    snapshot.data!.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 16),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
