import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:your_financial_assistant_app/src/repos/transactions.dart';

class MonthlyStatisticsChart extends StatelessWidget {
  final TransactionsRepo transactionsRepo = Get.find();

  MonthlyStatisticsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'monthly_transaction_statistics'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            SizedBox(
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
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: const Color(0xff37434d),
                            width: 1,
                          ),
                        ),
                        minX: 0,
                        maxX: snapshot.data!.length.toDouble() - 1,
                        minY: 0,
                        maxY: snapshot.data!.values
                                .reduce((a, b) => a > b ? a : b) +
                            1,
                        lineBarsData: [
                          LineChartBarData(
                            spots: _generateSpots(snapshot.data!),
                            isCurved: true,
                            color: Colors.blue,
                          ),
                        ],
                        titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            getTitlesWidget: (value, titleMeta) {
                              final months =
                                  _extractMonths(snapshot.data!.keys);
                              if (value >= 0 && value < months.length) {
                                return Text(months[value.toInt()]);
                              }
                              return Text('');
                            },
                          ),
                        )),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _extractMonths(Iterable<String> dateStrings) {
    return dateStrings.map((dateString) {
      // Assuming the date strings are in the format "(YYYY-MM)"
      return dateString.replaceAll(RegExp(r'[^0-9-]'), '');
    }).toList();
  }

  List<FlSpot> _generateSpots(Map<String, double> monthlyStatistics) {
    int index = 0;
    return monthlyStatistics.entries.map((entry) {
      return FlSpot(index.toDouble(), entry.value);
    }).toList();
  }
}
