import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expense_planner/providers/transactions.dart';

import 'package:expense_planner/screens/my_home_page.dart';

void main() {
  /*//SystemChrome.setPreferredOrientations help u to make ur app orientation be at portrait mode only.
  //We need to use WidgetsFlutterBinding.ensureInitialized because sometimes systemChorme does not work on some devices.
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Transactions(),
      child: MaterialApp(
        title: 'Personal Expenses Planner',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                button: TextStyle(
                  color: Colors.white,
                ),
              ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

/*
class MytHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MytHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
    Transaction(
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
    ),
  ];

  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  /*
  We use this method which is inherit from WidgetsBindingObserver Class
  to listen to the app state (active, inactive, etc...)
  Note:we need to add observer at initState method to start listening and
  we need to remove the observer at dispose method to avoid memory leaking.
  */
  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    print(appState);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.dateTime.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTx(String txTitle, double txAmount, DateTime selectedDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      dateTime: selectedDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addNewTx),
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandScapeContent(double screenSize) {
    return [
      Container(
        height: screenSize * 0.2,
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
              height: screenSize * 0.8,
              child: Chart(_recentTransactions),
            )
          : Container(
              height: screenSize * 0.8,
              child: TransactionList(_userTransactions, _deleteTransaction),
            ),
    ];
  }

  List<Widget> _buildPortraitContent(double screenSize) {
    return [
      Container(
        height: screenSize * 0.3,
        child: Chart(_recentTransactions),
      ),
      Container(
        height: screenSize * 0.7,
        child: TransactionList(_userTransactions, _deleteTransaction),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = (Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Personal Expenses Planner'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //was not working when the course is released
                IconButton(
                  icon: Icon(CupertinoIcons.add),
                  onPressed: () => _startAddNewTransaction(context),
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
            title: const Text('Personal Expenses Planner'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          )) as PreferredSizeWidget;
    final screenHeight = mediaQuery.size.height -
        (appBar.preferredSize.height + mediaQuery.padding.top);
    final pageBody = SafeArea(
      //SafeArea used because of the notch take a space from the height of the screen.
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandScape)
              ..._buildLandScapeContent(
                screenHeight,
              ),
            if (!isLandScape)
              ..._buildPortraitContent(
                screenHeight,
              ),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget?,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
*/
