import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));

      var totalSum = 0.0;
      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].dateTime.day == weekDay.day &&
            recentTransactions[i].dateTime.month == weekDay.month &&
            recentTransactions[i].dateTime.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'Day': DateFormat.E().format(weekDay).substring(0, 1),
        'Amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpendingAmount {
    //fold allows us to change a list to another type with a certain logic we difine in the function.
    //we pass to fold an anonymous function and besides that as a first argument, we pass a starting value in.
    //at this case our starting value is 0.0 (double value) and the second argument is a function returns a value is added to 0.0
    double total = groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['Amount'] as num);
    });
    if (total == 0)
      return 1;
    else
      return total;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['Day'] as String?,
                data['Amount'] as double?,
                totalSpendingAmount,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
