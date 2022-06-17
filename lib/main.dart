import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/chart.dart';
import './widgets/new_transactions.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses planner',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'lato',
          primarySwatch: Colors.cyan,
          accentColor: Colors.amber,
          textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: TextStyle(
                  fontFamily: 'lato',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 1,
                  wordSpacing: 2,
                  fontStyle: FontStyle.italic)),
          appBarTheme: AppBarTheme(
              backwardsCompatibility: false,
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: 'raleway',
                  fontWeight: FontWeight.bold,
                  fontSize: 22))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  //With is known as mix in which allows us to get features of different classes without directly inheriting from them since we can only inherit from one class
  // Data of the list of transactions
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    // Transaction(
    //      id: 't2', title: 'Weekly Groceries', amount: 100, date: DateTime.now()),
  ];

  // For the switch
  bool _chart = false;

  // getter to get the transactions that happened the week before
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((e) {
      return e.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  // adds new transactions, this is sent to the newTransaction widget class
  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTransaction = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: date);
    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  // deletes transactions, this is sent to the reansactionList widget class
  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  // pops up the new transaction sheet, this is passed to the buttons in the bar and at the pagebottom
  void _AddNewTransactionSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            child: NewTransaction(_addNewTransaction),
            onTap: () {},
            behavior: HitTestBehavior.opaque, // to cover what's underneath it
          );
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
// This method is called whenever lifecycles state changes (whenever the app reaches a new in lifecycle)
  void didChangeAppLifeCycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(
        this); // in order to do this we have to set up a listener using init
  }

// Outsourcing widgets in the widget tree to improve its appearance
  List<Widget> _buildLandscape(AppBar appBar, Widget list) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _chart,
              onChanged: (e) {
                setState(() {
                  _chart = e;
                });
              }),
        ],
      ),
      _chart
          ? Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.7,
              child: Chart(_recentTransactions))
          : list
    ];
  }

  List<Widget> _buildPortrait(AppBar appBar, Widget list) {
    return [
      Container(
          height: (MediaQuery.of(context).size.height -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top) *
              0.3,
          child: Chart(_recentTransactions)),
      list
    ];
  }

  Widget _appBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expenses Planner'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _AddNewTransactionSheet(context),
                )
              ],
            ),
          ) as PreferredSizeWidget
        : AppBar(
            title: Text('Expenses Planner',
                style: Theme.of(context).appBarTheme.titleTextStyle),
            actions: <Widget>[
              IconButton(
                  onPressed: () => _AddNewTransactionSheet(context),
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ))
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    // landscape mode
    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // the app bar
    final appBar = _appBar();

    // Building the transaction list
    final list = Container(
        height: (MediaQuery.of(context).size.height -
                (appBar as PreferredSizeWidget).preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    // Building the body of the application
    final body = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          if (landscape) ..._buildLandscape(appBar as AppBar, list),
          if (!landscape) ..._buildPortrait(appBar as AppBar, list),
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    ));

    //Painting the application
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: body,
            navigationBar: appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            appBar: appBar as PreferredSizeWidget,
            body: body,
            // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () => _AddNewTransactionSheet(context),
                  ),
          );
  }
}
