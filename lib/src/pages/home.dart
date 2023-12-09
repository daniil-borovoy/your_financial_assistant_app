import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:your_financial_assistant_app/src/pages/pages.dart';
import 'package:your_financial_assistant_app/src/repos/transactions.dart';
import 'package:your_financial_assistant_app/src/widgets/ask_for_help.dart';
import 'package:your_financial_assistant_app/src/widgets/chart.dart';
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
        title: Text('Home'.tr),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(SettingsPage.create());
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
          return const Center(
            child: Text("No transactions added, add one"),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        "Полезная статистика по транзакциям",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const TransactionChartWidget(),
                    TransactionStatisticsWidget(),
                    TransactionMonthChart(),
                    const SizedBox(height: 30),
                    AskAssistantButton(
                        onPressed: () => widget.changePageIndex(2)),
                    const SizedBox(height: 30),
                    const CurrencyStatisticsWidget(statistics: {
                      "Date": "2023-12-02T11:30:00+03:00",
                      "PreviousDate": "2023-12-01T11:30:00+03:00",
                      "PreviousURL":
                          "\/\/www.cbr-xml-daily.ru\/archive\/2023\/12\/01\/daily_json.js",
                      "Timestamp": "2023-12-04T16:00:00+03:00",
                      "Valute": {
                        "AUD": {
                          "ID": "R01010",
                          "NumCode": "036",
                          "CharCode": "AUD",
                          "Nominal": 1,
                          "Name": "Австралийский доллар",
                          "Value": 59.3416,
                          "Previous": 58.8892
                        },
                        "AZN": {
                          "ID": "R01020A",
                          "NumCode": "944",
                          "CharCode": "AZN",
                          "Nominal": 1,
                          "Name": "Азербайджанский манат",
                          "Value": 52.8011,
                          "Previous": 52.107
                        },
                        "GBP": {
                          "ID": "R01035",
                          "NumCode": "826",
                          "CharCode": "GBP",
                          "Nominal": 1,
                          "Name": "Фунт стерлингов Соединенного королевства",
                          "Value": 113.6027,
                          "Previous": 112.4724
                        },
                        "AMD": {
                          "ID": "R01060",
                          "NumCode": "051",
                          "CharCode": "AMD",
                          "Nominal": 100,
                          "Name": "Армянских драмов",
                          "Value": 22.2801,
                          "Previous": 21.9997
                        },
                      }
                    }),
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
          margin: EdgeInsets.symmetric(vertical: 5),
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
