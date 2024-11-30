import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/category/category_db.dart';
import 'package:flutter_application_1/db/transactions/transaction_db.dart';
import 'package:flutter_application_1/model/category/category_model.dart';
import 'package:flutter_application_1/model/transactions/transaction_model.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_dismissible_tile/flutter_dismissible_tile.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refreshUI();
    CategoryDB.instance.refreshUI();
    return Card(
      elevation: 50,
      shadowColor: Colors.blueGrey,
      child: ValueListenableBuilder(
        valueListenable: TransactionDB.instance.TransactionListNotifier,
        builder: (BuildContext ctx, List<TransactionModel> value, Widget? _) {
          return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemBuilder: (ctx, index) {
                final transaction = value[index];
                
                return ListTile(
                    leading: CircleAvatar(
                        radius: 50,
                        backgroundColor:
                            transaction.type == CategoryType.income
                                ? Colors.green
                                : Colors.amber,
                        child: Text(
                          parseDate(transaction.date),
                          textAlign: TextAlign.center,
                        )),
                    title: Text(
                      style: const TextStyle(fontSize: 20),
                        'Rs ${transaction.amount} \nPurpose: ${transaction.purpose}'),
                    subtitle: Text(transaction.category.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        print('Im here in delete icon');
                        TransactionDB.instance
                            .deleteTransaction(transaction.id!);
                      },
                    ));
              },
              separatorBuilder: (ctx, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: value.length);
        },
      ),
    );
  }

  String parseDate(DateTime date) {
    String str = DateFormat.MMMd().format(date);
    final splitted = str.split(' ');
    str = '${splitted[1]}\n${splitted[0]}';
    return str;
  }
}
