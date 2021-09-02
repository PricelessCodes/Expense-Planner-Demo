import 'package:flutter/material.dart';

import 'package:expense_planner/Models/transaction.dart';

import 'package:expense_planner/local_database/sqflite_database.dart';

class Transactions with ChangeNotifier {
  List<Transaction> _userTransactions = [
    /*Transaction(
      id: 't1',
      title: 'Weekly Fees',
      amount: 300.99,
      dateTime: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: 't2',
      title: 'Mobile',
      amount: 150.99,
      dateTime: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: 't3',
      title: 'Charger',
      amount: 80.99,
      dateTime: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: 't4',
      title: 'Labtop',
      amount: 1500.99,
      dateTime: DateTime.now().subtract(Duration(days: 4)),
    ),
    Transaction(
      id: 't5',
      title: 'Weekly Fees',
      amount: 300.99,
      dateTime: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: 't6',
      title: 'Mobile',
      amount: 150.99,
      dateTime: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: 't7',
      title: 'Charger',
      amount: 80.99,
      dateTime: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: 't8',
      title: 'Labtop',
      amount: 1500.99,
      dateTime: DateTime.now().subtract(Duration(days: 4)),
    ),*/
  ];

  List<Transaction> get userTransactions {
    _userTransactions.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return [..._userTransactions];
  }

  Future<void> fetchAndSetTransactions() async {
    final dataList = await SqfliteDatabase.getDatebase('user_transactions');
    _userTransactions = dataList
        .map(
          (tx) => Transaction(
            id: tx['id'],
            title: tx['title'],
            amount: tx['amount'],
            dateTime: DateTime.parse(tx['dateTime']),
          ),
        )
        .toList();
    notifyListeners();
  }

  List<Transaction> get recentTransactions {
    return _userTransactions.where((tx) {
      return tx.dateTime.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  Future<void> addNewTx(
      String txTitle, double txAmount, DateTime selectedDate) async {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      dateTime: selectedDate,
    );

    _userTransactions.add(newTx);

    notifyListeners();

    final count = await SqfliteDatabase.insert(
      'user_transactions',
      {
        'id': newTx.id,
        'title': newTx.title,
        'amount': newTx.amount,
        'dateTime': newTx.dateTime.toString(),
      },
    );
    if (count == 0) {
      _userTransactions.removeWhere((tx) => tx.id == newTx.id);
    }
  }

  Future<void> deleteTransaction(String txId) async {
    final tx = _userTransactions.firstWhere((tx) => tx.id == txId);
    _userTransactions.removeWhere((tx) => tx.id == txId);

    notifyListeners();

    final count = await SqfliteDatabase.delete(
      'user_transactions',
      txId,
    );

    if (count == 0) {
      _userTransactions.add(tx);
    }
  }
}
