import 'package:expense_planner/providers/transactions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/transaction_item.dart';

class TransactionList extends StatefulWidget {
  const TransactionList();

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  late final _future;
  @override
  initState() {
    super.initState();
    _future = Provider.of<Transactions>(context, listen: false)
        .fetchAndSetTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Faild to retrive data try to clear data.'));
          }
          return Consumer<Transactions>(
            builder: (ctx, transactions, ch) {
              return transactions.userTransactions.isEmpty
                  ? LayoutBuilder(
                      builder: (ctx, constrains) {
                        return Column(
                          children: <Widget>[
                            Container(
                              height: constrains.maxHeight * 0.1,
                              child: Text(
                                'No transactions added yet!',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            SizedBox(
                              //badal el margin ely fel Container
                              height: constrains.maxHeight * 0.001,
                            ),
                            Container(
                              height: constrains.maxHeight * 0.7,
                              //margin: EdgeInsets.only(top: 20),
                              child: Image.asset(
                                'assets/images/waiting.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  : ListView(
                      children:
                          transactions.userTransactions.reversed.map((tx) {
                        return TransactionItem(
                            key: ValueKey(tx.id),
                            transaction: tx,
                            deleteTransaction: transactions.deleteTransaction);
                      }).toList(),
                    );
            },
          );
        });
  }
}

/* My styling for each transaction
Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          '\$${transactions[index].amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            transactions[index].title,
                            style: Theme.of(context).textTheme.title,
                          ),
                          Text(
                            DateFormat.yMMMEd()
                                .format(transactions[index].dateTime),
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
 */
