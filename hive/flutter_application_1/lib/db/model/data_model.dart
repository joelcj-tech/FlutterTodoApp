// import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'data_model.g.dart';

@HiveType(typeId: 1) // primary key to identify table(class student)
class StudentModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String age;

  StudentModel({required this.name, required this.age, this.id});
}

// flutter packages pub run build_runner watch --use-polling-watcher --delete-conflicting-outputs