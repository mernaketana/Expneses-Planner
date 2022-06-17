import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function delete;

  const TransactionList(this.transactions, this.delete);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: Image.asset(
                    'assets/images/background.png',
                    fit: BoxFit.cover,
                    height: constraints.maxHeight * 0.8,
                  ),
                )
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return TransactionItem(
                  key: ValueKey(transactions[index]
                      .id), // UniqueKey(), //gives every item a unique key
                  transaction: transactions[index],
                  delete: delete);
              // return Card(
              //   elevation: 5,
              //   margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              //   child: ListTile(
              //     leading: CircleAvatar(
              //       backgroundColor: Theme.of(context).primaryColor,
              //       radius: 30,
              //       child: Padding(
              //         padding: EdgeInsets.all(2),
              //         child: FittedBox(
              //           child: Text(
              //             ' \$ ${transactions[index].amount.toStringAsFixed(2)}',
              //             style: TextStyle(
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold),
              //           ),
              //         ),
              //       ),
              //     ),
              //     title: Text(
              //       transactions[index].title,
              //       style: Theme.of(context).textTheme.titleLarge,
              //     ),
              //     subtitle: Text(
              //       DateFormat.yMMMd().format(transactions[index].date),
              //       style: TextStyle(color: Colors.black54),
              //     ),
              //   ),
              // );
            },
            itemCount: transactions.length,
          );
  }
}
