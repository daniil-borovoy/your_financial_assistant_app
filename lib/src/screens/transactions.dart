import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:your_financial_assistant_app/src/models/transaction.dart';
import 'package:your_financial_assistant_app/src/repos/transactions.dart';
import 'package:your_financial_assistant_app/src/screens/add_transaction.dart';
import 'package:your_financial_assistant_app/src/screens/transactions_csv_import.dart';
import 'package:your_financial_assistant_app/src/widgets/loading_indicator.dart';
import 'package:your_financial_assistant_app/src/widgets/transaction_card.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  static const _pageSize = 20;

  final TransactionsRepo transactionsRepo = Get.find();

  final PagingController<int, Transaction> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems =
          await transactionsRepo.getItems(page: pageKey, limit: _pageSize);
      final isLastPage = newItems.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('transactions'.tr),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _pagingController.refresh();
        },
        child: PagedListView<int, Transaction>(
          pagingController: _pagingController,
          padding: const EdgeInsets.only(bottom: 100),
          builderDelegate: PagedChildBuilderDelegate<Transaction>(
            itemBuilder: (context, item, index) => TransactionCard(
              transaction: item,
              onDeleted: () => _pagingController.refresh(),
            ),
            firstPageProgressIndicatorBuilder: (context) {
              return const PulseLoadingIndicator();
            },
            animateTransitions: true,
            noItemsFoundIndicatorBuilder: (context) {
              return Center(
                  child: Text(
                'no_transactions_found'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ));
            },
          ),
        ),
      ),
      floatingActionButton: _buildSpeedDial(),
    );
  }

  SpeedDial _buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 22.0),
      visible: true,
      curve: Curves.bounceIn,
      childMargin: const EdgeInsets.all(20),
      spacing: 10,
      children: [
        SpeedDialChild(
          shape: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: const Icon(Icons.add),
          backgroundColor: Colors.blue,
          label: 'add_transaction'.tr,
          onTap: () {
            Navigator.of(context)
                .push(TransactionCreationPage.create())
                .then((value) {
              if (value != null) {
                _pagingController.refresh();
              }
            });
          },
        ),
        SpeedDialChild(
          shape: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: SvgPicture.asset(
            'assets/csv.svg', // Replace with your SVG asset path
            height: 30,
            width: 30,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          backgroundColor: Colors.green,
          label: 'csv_import'.tr,
          onTap: () {
            // CSV import logic
            Navigator.of(context)
                .push(TransactionsCSVImportScreen.create())
                .then((value) {
              if (value != null) {
                _pagingController.refresh();
              }
            });
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
