import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/functions/db_functions.dart';
import 'package:flutter_application_1/screens/widgets/add_student_widget.dart';
import 'package:flutter_application_1/screens/widgets/list_student_widget.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          AddStudentWidget(),
          const Expanded(child: ListStudentWidget()),
        ],
      ),
    ));
  }
}
