import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/category/category_db.dart';
import 'package:flutter_application_1/db/transactions/transaction_db.dart';
import 'package:flutter_application_1/model/category/category_model.dart';
import 'package:flutter_application_1/model/transactions/transaction_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = 'add--transaction';
  const ScreenAddTransaction({super.key});

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}
// Purpose
// amount
// category type
// date
// category

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? selectedDate;
  // CategoryType? selectedCategoryType;
  ValueNotifier<CategoryType> selectedCategoryType =
      ValueNotifier(CategoryType.income);
  CategoryModel? selectedCategoryModel;

  String? categoryID;

  final purposeTextEditingController = TextEditingController();
  final amountTextEditingController = TextEditingController();

  // @override
  // void initState() {
  //   //runs only once, doesnt gets rebuil like the build method
  //   //initState works before the Build method
  //   CategoryDB.instance.refreshUI();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  // Purpose
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: purposeTextEditingController,
                      decoration: const InputDecoration(hintText: 'Purpose'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      //Amount
                      controller: amountTextEditingController,
                      decoration: const InputDecoration(
                        hintText: 'Amount',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Radio(
                              value: CategoryType.income,
                              groupValue: selectedCategoryType.value,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  selectedCategoryType.value = value;
                                  categoryID = null;
                                });
                              }),
                          const Text('Income'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                              value: CategoryType.expense,
                              groupValue: selectedCategoryType.value,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  selectedCategoryType.value = value;
                                  categoryID = null;
                                });
                              }),
                          const Text('Expense'),
                        ],
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 30)),
                          lastDate: DateTime.now());
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text((selectedDate == null)
                        ? 'Select Date'
                        : selectedDate.toString()),
                  ),
                  DropdownButton(
                    hint: const Text('Select Category'),
                    value: categoryID,
                    items: (selectedCategoryType.value == CategoryType.income
                            ? CategoryDB().incomeCategoryList
                            : CategoryDB().expenseCategoryList)
                        .value
                        .map((e) {
                      return DropdownMenuItem(
                          value: e.id,
                          onTap: () {
                            selectedCategoryModel = e;
                          },
                          child: Text(e.name));
                    }).toList(),
                    onChanged: (selectedcategory) {
                      setState(() {
                        categoryID = selectedcategory;
                      });
                    },
                  ),
                  //submit
                  ElevatedButton(
                    onPressed: () async {
                      await addTransaction();
                      await TransactionDB.instance.getTransactions();
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          height: 20,
        )
      ],
    )));
  }

  Future<void> addTransaction() async {
    final String purpose = purposeTextEditingController.value.text;
    var amount = amountTextEditingController.text;
    // amount = '24000';
    // final amount = 250000.00;
    final CategoryType type = selectedCategoryType.value;
    final DateTime? date = selectedDate;
    final CategoryModel? category = selectedCategoryModel;
    if (purpose.isEmpty) {
      print('error 1');
      return;
    }
    if (date == null) {
      print('error 2');
      return;
    }
    if (category == null) {
      print('error 3');
      return;
    }
    final parsedAmount = double.tryParse(amount);
    // var parsedAmount = null;
    print(amount);
    if (parsedAmount == null) {
      print('error 4');
      return;
    }
    final model = TransactionModel(
        purpose: purpose,
        amount: parsedAmount,
        date: date,
        type: type,
        category: category);
    TransactionDB.instance.insertTransaction(model);
    Navigator.of(context).pop();
    TransactionDB.instance.refreshUI();
  }
}
