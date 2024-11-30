// import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/model/data_model.dart';
import 'package:flutter_application_1/screens/widgets/list_student_widget.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter/src/foundation/change_notifier.dart';

ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);

Future<void> addStudent(StudentModel value) async {
  //studentListNotifier.value.add(value);
  // since we give await here, the function needs to be async and future
  final studentDB = await Hive.openBox<StudentModel>(
      'student_db'); //opens a table named 'student_db' of type studentModel
  // here we get a database studentDB
  studentDB.add(value); // adding value to database, now we need to refresh UI

  // studentListNotifier.addListener(getAllStudents);
  // studentListNotifier.notifyListeners();

  getAllStudents();
}

Future<void> getAllStudents() async {
  ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);
  final studentDB = await Hive.openBox<StudentModel>('student_db');
  studentListNotifier.value.clear();
  // await studentDB.clear(); //to clear the whole db
  print('Yes');
  studentListNotifier.value.addAll(studentDB.values); //since we are adding a whole list not just a single data
  studentListNotifier.notifyListeners();
}

Future<void> deleteStudent(int? id) async{

}