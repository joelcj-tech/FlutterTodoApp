import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home/screen_home.dart';

class MoneyManagerBottomNavigation extends StatelessWidget {
  const MoneyManagerBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedIndexNotifier,
      builder: (BuildContext ctx, int updatedIndex, Widget?_) {
        return BottomNavigationBar(
          selectedItemColor: Colors.purpleAccent,
          unselectedItemColor: Colors.grey,
            backgroundColor: Colors.amberAccent,
            currentIndex: updatedIndex,   //what is achieved from this assignment
            onTap: (newIndex) {   //from where does this newIndex comes from
              ScreenHome.selectedIndexNotifier.value = newIndex;
            },
            items: const [    //this is just a list of items, how does this relates to the concerned pages
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'Transactions'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'Categories'),
            ]);
      },
    );
  }
}
