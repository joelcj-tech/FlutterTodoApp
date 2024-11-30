// ignore_for_file: constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/model/category/category_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

const CATEGORY_DB_NAME = 'category-database'; //from where did this name came

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryId);
  
}

class CategoryDB implements CategoryDbFunctions {
  CategoryDB.internal(); //named constructor

  static CategoryDB instance = CategoryDB.internal();

  factory CategoryDB() {
    // factory creates an object of the class onlyif no other objects have been created
    return instance;
  } //Making it a singleton class, so only 1 object will be created

  ValueNotifier<List<CategoryModel>> incomeCategoryList = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryList = ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    //await _categoryDB.add(value); .add adds the value to database and an automatic id will be generated even though we provide an id
    await _categoryDB.put(value.id, value);
    await refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _categoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    incomeCategoryList.value.clear();
    expenseCategoryList.value.clear();
    final _allCategories = await getCategories();
    await Future.forEach(
      _allCategories,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          incomeCategoryList.value.add(category);
        } else {
          expenseCategoryList.value.add(category);
        }
      },
    );
    incomeCategoryList.notifyListeners(); //this works
    expenseCategoryList.notifyListeners();
  } 

  @override
  Future<void> deleteCategory(String categoryId) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    _categoryDB.delete(categoryId);
    refreshUI();
  }
  
  

}
