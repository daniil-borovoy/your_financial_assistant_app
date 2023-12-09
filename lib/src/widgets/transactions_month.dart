import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:your_financial_assistant_app/src/repos/transactions.dart';

class TransactionMonthChart extends StatelessWidget {
  final TransactionsRepo transactionsRepo = Get.find();

  TransactionMonthChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
        child: SizedBox(
          height: 300,
          child: FutureBuilder<Map<String, double>>(
            future: transactionsRepo.getMonthlyStatistics(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(
                      show: true,
                      border:
                          Border.all(color: const Color(0xff37434d), width: 1),
                    ),
                    minX: 0,
                    maxX: snapshot.data!.length.toDouble() - 1,
                    minY: 0,
                    maxY:
                        snapshot.data!.values.reduce((a, b) => a > b ? a : b) +
                            1,
                    lineBarsData: [
                      LineChartBarData(
                        spots: _generateSpots(snapshot.data!),
                        isCurved: true,
                        color: Colors.blue,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  List<FlSpot> _generateSpots(Map<String, double> monthlyStatistics) {
    int index = 0;
    return monthlyStatistics.entries.map((entry) {
      return FlSpot((index++).toDouble(), entry.value);
    }).toList();
  }
}
