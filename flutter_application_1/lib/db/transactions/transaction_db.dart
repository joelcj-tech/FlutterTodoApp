import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/transactions/transaction_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

const TRANSACTION_DB_NAME = 'transaction-db';

abstract class TransactionDBFunctions {
  Future<void> insertTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getTransactions();
  Future<void> refreshUI();
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactionDBFunctions {
  TransactionDB.internal();

  static TransactionDB instance = TransactionDB.internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> TransactionListNotifier =
      ValueNotifier([]);

  @override
  Future<void> insertTransaction(TransactionModel transaction) async {
    final db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await db.put(transaction.id, transaction);
    print('Im in insert');
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return db.values.toList();
  }

  @override
  Future<void> refreshUI() async {
    TransactionListNotifier.value.clear();
    final allTransactions = await getTransactions();
    allTransactions.sort((second, first) => first.date.compareTo(second.date));
    TransactionListNotifier.value.addAll(allTransactions);
    TransactionListNotifier.notifyListeners();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    db.delete(id);
    refreshUI();
  }
}
