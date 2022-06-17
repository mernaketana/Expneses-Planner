import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart(this.recentTransactions);

  // getter to create the 7 bras (days of the week)
  List<Map<String, Object>> get bars {
    return List.generate(7, (index) {
      final day = DateTime.now().subtract(Duration(days: index));
      var sum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == day.day &&
            recentTransactions[i].date.month == day.month &&
            recentTransactions[i].date.year == day.year) {
          sum += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(day).substring(0, 1),
        'amount': sum,
      }; //To get the day today and the the days for a week before today
    }).reversed.toList();
  }

  // equivalent to reduce in js. It will add all amounts of the seven bars
  double get spendings {
    return bars.fold(0.0, (sum, e) {
      return sum + (e['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: bars.map((e) {
              return Expanded(
                // The same as flex but with fit always set to tight
                child: ChartBar(
                    title: e['day'].toString(),
                    amount: e['amount'] as double,
                    percentage: spendings == 0.0
                        ? 0.0
                        : (e['amount'] as double) / spendings),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
