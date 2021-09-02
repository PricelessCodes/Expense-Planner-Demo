import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expense_planner/providers/transactions.dart';

import 'package:expense_planner/Widgets/chart.dart';
import 'package:expense_planner/Widgets/transaction_list.dart';

class PortraitContent extends StatelessWidget {
  final double screenHeight;
  const PortraitContent({Key? key, required this.screenHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: screenHeight * 0.3,
          child: Consumer<Transactions>(
            builder: (ctx, transactions, ch) {
              return Chart(transactions.recentTransactions);
            },
          ),
        ),
        Container(
          height: screenHeight * 0.7,
          child: TransactionList(),
        ),
      ],
    );
  }
}
