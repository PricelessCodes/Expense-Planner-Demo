import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:expense_planner/Widgets/my_home_page_body.dart';
import 'package:expense_planner/Widgets/new_transaction.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;

    void _startAddNewTransaction() {
      showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(),
          );
        },
      );
    }

    final PreferredSizeWidget appBar = (Platform.isIOS
        ? CupertinoNavigationBar(
            leading: Padding(
                padding: EdgeInsets.all(5),
                child:
                    CircleAvatar(child: Image.asset('assets/images/Logo.png'))),
            middle: const Text('Personal Expenses Planner'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //was not working when the course is released
                IconButton(
                  icon: Icon(CupertinoIcons.add),
                  onPressed: () => _startAddNewTransaction(),
                ),
                //the instructor said we can make our iconButton as shown next.
                /*GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                ),*/
              ],
            ),
          )
        : AppBar(
            leading: Padding(
                padding: EdgeInsets.all(5),
                child: Image.asset(
                  'assets/images/Logo.png',
                  fit: BoxFit.contain,
                )),
            titleSpacing: 0,
            title: FittedBox(child: const Text('Personal Expenses Planner')),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(),
              ),
            ],
          )) as PreferredSizeWidget;
    final screenHeight = mediaQuery.size.height -
        (appBar.preferredSize.height + mediaQuery.padding.top);

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget?,
            child: MyHomePageBody(
                isLandScape: isLandScape, screenHeight: screenHeight),
          )
        : Scaffold(
            appBar: appBar,
            body: MyHomePageBody(
                isLandScape: isLandScape, screenHeight: screenHeight),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(),
                  ),
          );
  }
}
