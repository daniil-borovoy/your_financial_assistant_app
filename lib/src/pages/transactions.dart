import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:your_financial_assistant_app/main.dart';
import 'package:your_financial_assistant_app/src/models/transaction.dart';
import 'package:your_financial_assistant_app/src/pages/add_transaction.dart';
import 'package:your_financial_assistant_app/src/widgets/loading_indicator.dart';
import 'package:your_financial_assistant_app/src/widgets/transaction_card.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  static const _pageSize = 20;

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
      // await Future.delayed(Duration(seconds: 10));
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
        title: Text('Транзакции'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _pagingController.refresh();
        },
        child: PagedListView<int, Transaction>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Transaction>(
            itemBuilder: (context, item, index) => TransactionCard(
              transaction: item,
            ),
            firstPageProgressIndicatorBuilder: (context) {
              return const PulseLoadingIndicator();
            },
            animateTransitions: true,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(TransactionCreationPage.create())
              .then((value) {
            if (value != null) {
              _pagingController.refresh();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
