import 'dart:io';
import 'package:expenses_planner/widgets/adaptive_flat_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _pickedDate;

// WIDGET LIFECYCLE
//   @override
//   // A method that gets called the first time the state is created
//   // often used to make http requests and load some data from a serveror a database
//   void initState(){
//     super.initState(); // Super is a keyword in dart which refers to the parent class which is the State object here and that to make sure that not only our init method is executed but also the one in the state object
//   }

// @override
//   // A method that's triggered whenevr the widget to which the state belongs is updated
//   void didUpdateWidget(NewTransaction oldWidget){
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   // A method that's triggered whenevr the widget is removed permenantly
//   void dispose() {
//     super.dispose();
//   }

  // Function to show the date picker and return the picked date
  void _datePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date == null) {
        return;
      }
      setState(() {
        _pickedDate = date;
      });
    });
  }

// Future is a class built into dart that allows us to create objects which will give a va;ue in the future
// also used with http requests when you have to wait for the response from the server
// here we use it since we wait for the user to pick a value

  // Function to submit amount, title and date picked when the user enters them to the transactionlist so that a new transaction is shown
  void _submit() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _pickedDate == null) {
      return;
    }
    widget.addTransaction(enteredTitle, enteredAmount,
        _pickedDate); // widget accesses the class from the state
    Navigator.of(context)
        .pop(); // context gives access to the context of the widget itself
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title:'),
                controller: _titleController,
                onSubmitted: (_) => _submit(),
                //onChanged: (e) => titleInput = e,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount:'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) =>
                    _submit(), // _ I have to accept an argument but I don't care about it
                //onChanged: (e) => amountInput = e,
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_pickedDate == null
                          ? 'No Date Chosen!'
                          : DateFormat.yMd().format(_pickedDate as DateTime)),
                    ),
                    AdaptiveFlatButton('Choose Date', _datePicker)
                  ],
                ),
              ),
              RaisedButton(
                color: Theme.of(context).accentColor,
                onPressed: _submit,
                child: Text('Add Transaction'),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
