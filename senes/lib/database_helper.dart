import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  DBHelper._privateConstructor();

  static DBHelper dbHelper = DBHelper._privateConstructor();

  late Database _database;

  Future<Database> get database async {
    _database = await _createDatabase();

    return _database;
  }

  Future<Database> _createDatabase() async {
    Database database =
    await openDatabase(join(await getDatabasesPath(), 'mydb.db'),
        onCreate: (Database db, int version) {
          db.execute("CREATE TABLE Users(id TEXT, firstName TEXT, lastName TEXT, email TEXT), "
              "CREATE TABLE Workouts(workoutId TEXT, workoutName TEXT, workoutLength TEXT, workoutDetails)");
        }, version: 1);
    return database;
  }