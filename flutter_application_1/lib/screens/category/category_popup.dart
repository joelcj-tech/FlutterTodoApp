import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/category/category_db.dart';
import 'package:flutter_application_1/model/category/category_model.dart';

ValueNotifier<CategoryType> categorytypeNotifier =
    ValueNotifier(CategoryType.income);
final _nameEditingController = TextEditingController();
Future<void> showCategoryPopup(BuildContext context) async {
  showDialog(
      context: context, //learn about context, what is it
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Add Category'),
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextFormField(
                controller: _nameEditingController,
                decoration: const InputDecoration(
                  hintText: 'Enter here',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  RadioButton(title: 'Income', type: CategoryType.income),
                  RadioButton(title: 'Expense', type: CategoryType.expense)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  final _name = _nameEditingController.text;
                  if (_name.isEmpty) {
                    return;
                  }
                  final _type = categorytypeNotifier.value;
                  final category = CategoryModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _name,
                      type: _type);

                  CategoryDB().insertCategory(category);
                  Navigator.of(ctx).pop();
                },
                child: const Text('Add'),
              ),
            )
          ],
        );
      });
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type; //type passed in the function call by popup
  const RadioButton({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: categorytypeNotifier,
            builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
              return Radio(
                  value: type,
                  groupValue: categorytypeNotifier.value,
                  onChanged: (value) {
                    if (value == null) return;
                    categorytypeNotifier.value = value;
                    // categorytypeNotifier.notifyListeners();
                  });
            }),
        Text(title),
      ],
    );
  }
}
