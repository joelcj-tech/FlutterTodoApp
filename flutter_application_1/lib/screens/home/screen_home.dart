import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/category/category_popup.dart';
import 'package:flutter_application_1/screens/category/screen_category.dart';
import 'package:flutter_application_1/screens/home/widgets/bottom_navigation.dart';
import 'package:flutter_application_1/screens/transactions/screen_transactions.dart';
import 'package:flutter_application_1/screens/transactions/transaction_add.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  final _pages = const [ScreenTransaction(), ScreenCategory()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        centerTitle: true,
        backgroundColor: Colors.grey,
        title: const Text('Money Manager App'),
      ),
      bottomNavigationBar: const MoneyManagerBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable:
                selectedIndexNotifier, //this is changed by both the valuelistenablebuilder, why
            builder: (BuildContext context, int updatedIndex, _) {
              return _pages[updatedIndex]; //ok so this can change the pages
            }),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (selectedIndexNotifier.value == 0) {
              print('add transactions');
              Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
            } else {
              print('add category');
              showCategoryPopup(context);
            }
          },
          focusColor: Colors.deepPurple,
          backgroundColor: Colors.orangeAccent,
          child: const Icon(Icons.add)),
    );
  }
}
