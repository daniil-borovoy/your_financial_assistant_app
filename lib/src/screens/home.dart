import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:your_financial_assistant_app/src/repos/transactions.dart';
import 'package:your_financial_assistant_app/src/screens/screens.dart';
import 'package:your_financial_assistant_app/src/widgets/ask_for_help.dart';
import 'package:your_financial_assistant_app/src/widgets/transactions_distribution_by_category_chart.dart';
import 'package:your_financial_assistant_app/src/widgets/loading_indicator.dart';
import 'package:your_financial_assistant_app/src/widgets/monthly_statistics.dart';
import 'package:your_financial_assistant_app/src/widgets/transactions_month.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) changePageIndex;

  const HomeScreen({super.key, required this.changePageIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(SettingsScreen.create());
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: TransactionsStats(changePageIndex: changePageIndex),
    );
  }
}

class TransactionsStats extends StatefulWidget {
  final Function(int) changePageIndex;

  const TransactionsStats({super.key, required this.changePageIndex});

  @override
  State<StatefulWidget> createState() => _TransactionsStatsState();
}

class _TransactionsStatsState extends State<TransactionsStats> {
  final TransactionsRepo _transactionsRepo = Get.find();
  late Future<int> _future;

  @override
  void initState() {
    super.initState();
    _future = _transactionsRepo.countAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == 0) {
          return Center(
            child: Text(
              'no_transactions_found'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          );
        }

        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'useful_transaction_statistics'.tr,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TransactionDistributionByCategoryChart(),
                    TransactionStatisticsWidget(),
                    MonthlyStatisticsChart(),
                    const SizedBox(height: 30),
                    AskAssistantButton(
                      onPressed: () => widget.changePageIndex(2),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        }

        return const Center(child: PulseLoadingIndicator());
      },
    );
  }
}

class CurrencyStatisticsWidget extends StatelessWidget {
  final Map<String, dynamic> statistics;

  const CurrencyStatisticsWidget({super.key, required this.statistics});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text('Date: ${statistics["Date"]}'),
        // Text('Previous Date: ${statistics["PreviousDate"]}'),
        // Text('Timestamp: ${statistics["Timestamp"]}'),
        SizedBox(height: 10),
        Text('Currency Rates:'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildCurrencyRateWidgets(statistics["Valute"]),
        ),
      ],
    );
  }

  List<Widget> _buildCurrencyRateWidgets(Map<String, dynamic> valute) {
    List<Widget> widgets = [];

    valute.forEach((key, value) {
      widgets.add(
        Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            title: Text('${value["Name"]} (${value["CharCode"]})'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Value: ${value["Value"]}'),
                Text('Previous: ${value["Previous"]}'),
              ],
            ),
          ),
        ),
      );
    });

    return widgets;
  }
}
