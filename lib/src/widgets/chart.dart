import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:your_financial_assistant_app/src/models/transaction.dart';
import 'package:your_financial_assistant_app/src/repos/transactions.dart';

class TransactionChartWidget extends StatefulWidget {
  const TransactionChartWidget({super.key});

  @override
  State createState() => _TransactionChartWidgetState();
}

class _TransactionChartWidgetState extends State<TransactionChartWidget> {
  final TransactionsRepo _transactionsRepo = Get.find();
  Future<List<Transaction>>? _transactions;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      setState(() {
        _transactions = _transactionsRepo.getItems(limit: 10);
      });
    } catch (error) {
      print("Error loading transactions: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: FutureBuilder<List<Transaction>>(
        future: _transactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: _buildShipLoader());
          } else if (snapshot.hasError) {
            return Center(child: Text('loadingError'.tr));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('empty'.tr));
          } else {
            return TransactionChart(transactions: snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildShipLoader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.directions_boat,
          // You can replace this with your ship-themed icon
          size: 50,
          color: Colors.blue,
        ),
        const SizedBox(height: 10),
        Text('Loading'.tr),
      ],
    );
  }
}

class TransactionChart extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            borderData: FlBorderData(show: true),
            minX: 0,
            maxX: transactions.length.toDouble() - 1,
            minY: 0,
            maxY: transactions
                .map((transaction) => transaction.amount)
                .reduce((a, b) => a > b ? a : b),
            lineBarsData: [
              LineChartBarData(
                spots: transactions.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(), entry.value.amount);
                }).toList(),
                isCurved: true,
                color: Colors.blueAccent,
                barWidth: 4,
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
