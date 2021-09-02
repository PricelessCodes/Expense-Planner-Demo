import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expense_planner/providers/transactions.dart';

import 'package:expense_planner/Widgets/chart.dart';
import 'package:expense_planner/Widgets/transaction_list.dart';

class LandScapeContent extends StatefulWidget {
  final double screenHeight;
  const LandScapeContent({Key? key, required this.screenHeight})
      : super(key: key);

  @override
  _LandScapeContentState createState() => _LandScapeContentState();
}

class _LandScapeContentState extends State<LandScapeContent> {
  bool _showChart = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: widget.screenHeight * 0.2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Show Chart',
                style: Theme.of(context).textTheme.headline6,
              ),
              Switch.adaptive(
                value: _showChart,
                onChanged: (val) {
                  setState(() {
                    _showChart = val;
                  });
                },
              ),
            ],
          ),
        ),
        _showChart
            ? Container(
                height: widget.screenHeight * 0.8,
                child: Consumer<Transactions>(
                  builder: (ctx, transactions, ch) {
                    return Chart(transactions.recentTransactions);
                  },
                ),
              )
            : Container(
                height: widget.screenHeight * 0.8,
                child: TransactionList(),
              ),
      ],
    );
  }
}
