import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key?
        key, // every widget in flutter can have a key, however, most of them don't need it, especially stateless widget
    required this.transaction,
    required this.delete,
  }) : super(
            key:
                key); // By calling super you are instantiating the parent class, you do this when you want to pass extra added data to the class that is often the key
  // this syntax a short notation for calling the super constructor it's called a constructor initializer list

  final Transaction transaction;
  final Function delete;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color? color;

  @override
  void initState() {
    super.initState();
    const colors = [Colors.indigo, Colors.amber, Colors.red];
    color = colors[Random().nextInt(3)];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(children: <Widget>[
          Container(
            width: 100,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: color as Color,
                  width: 2,
                )),
            child: Center(
              child: FittedBox(
                child: Text(
                    ' \$ ${widget.transaction.amount.toStringAsFixed(2)}', // Two decimal places after the sign
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.white)),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.transaction.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                DateFormat.yMMMd().format(widget.transaction.date),
                style: TextStyle(color: Colors.black54),
              )
            ],
          ),
          Spacer(),
          MediaQuery.of(context).size.width > 500
              ? FlatButton.icon(
                  padding: EdgeInsets.all(5),
                  icon: const Icon(Icons.delete),
                  textColor: Theme.of(context).errorColor,
                  label: const Text('Delete'),
                  onPressed: () => widget.delete(widget.transaction.id),
                )
              : IconButton(
                  onPressed: () => widget.delete(widget.transaction.id),
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                ),
        ]),
      ),
    );
  }
}
