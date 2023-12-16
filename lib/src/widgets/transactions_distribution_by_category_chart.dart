import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:your_financial_assistant_app/src/models/transaction.dart';
import 'package:your_financial_assistant_app/src/repos/transactions.dart';

class TransactionDistributionByCategoryChart extends StatelessWidget {
  final TransactionsRepo _transactionsRepo = Get.find();

  TransactionDistributionByCategoryChart({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<TransactionCategory, double>>(
      future: _getCategoryTotals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: child,
              );
            },
            child: const SizedBox(
              width: double.infinity,
              height: 400,
              child: Card(
                elevation: 4,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<TransactionCategory, double> categoryTotals = snapshot.data!;
          return _buildChartWithTransition(categoryTotals);
        }
      },
    );
  }

  Future<Map<TransactionCategory, double>> _getCategoryTotals() async {
    final categoryTotals =
        await _transactionsRepo.getTransactionCategoryTotals();
    return categoryTotals;
  }

  Widget _buildChartWithTransition(
      Map<TransactionCategory, double> categoryTotals) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: _buildChart(categoryTotals),
    );
  }

  Widget _buildChart(Map<TransactionCategory, double> categoryTotals) {
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: _generateSections(categoryTotals),
              borderData: FlBorderData(
                show: false,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateSections(
      Map<TransactionCategory, double> categoryTotals) {
    List<PieChartSectionData> sections = [];

    categoryTotals.forEach((category, total) {
      sections.add(
        PieChartSectionData(
          color: _getCategoryColor(category),
          value: total,
          title: '${total.toStringAsFixed(2)} / ${category.name.tr}',
          radius: 100,
          titlePositionPercentageOffset: 0.5,
          titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _getCategoryColor(category).computeLuminance() >= 0.5
                ? Colors.black
                : Colors.white,
          ),
        ),
      );
    });

    return sections;
  }

  Color _getCategoryColor(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.groceries:
        return Colors.blue;
      case TransactionCategory.food:
        return Colors.green;
      case TransactionCategory.entertainment:
        return Colors.orange;
      case TransactionCategory.gas:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
