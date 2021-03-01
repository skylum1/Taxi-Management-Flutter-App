// import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:taxi/models/driver.dart';

class DatabaseHelperdriv {
  static DatabaseHelperdriv _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String driverTable = 'driver_table';
  String colId = 'id';
  String colName = 'name';
  String colPhone = 'phone';
  String colAddress = 'address';
  DatabaseHelperdriv._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelperdriv() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelperdriv
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    var result = await _database
        .query('sqlite_master', where: 'name = ?', whereArgs: ['$driverTable']);
    if (result.toString() == '[]') {
      _createDb(_database, 1);
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    String path = join(await getDatabasesPath(), 'notes.db');

    // Open/create the database at a given path
    var notesDatabase = await openDatabase(path, version: 1);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $driverTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, '
        '$colPhone TEXT, $colAddress TEXT)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getDriverMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(driverTable, orderBy: '$colId ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertDriver(Driver note) async {
    Database db = await this.database;
    var result = await db.insert(driverTable, note.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateDriver(Driver note) async {
    var db = await this.database;
    var result = await db.update(driverTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteDriver(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $driverTable WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $driverTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Driver>> searchDriver(Driver note, {int id}) async {
    Database db = await this.database;
    var noteMapList;
    if (id != null)
      noteMapList = await db.rawQuery(
          'SELECT * FROM $driverTable WHERE $colId = ? OR $colName = ? OR $colPhone = ? OR $colAddress = ?',
          [id, note.name, note.phone, note.address]);
    //await db.rawQuery('SELECT * FROM $driverTable WHERE $colId = $id');
    else
      noteMapList = await db.rawQuery(
          'SELECT * FROM $driverTable WHERE $colName = ? OR $colPhone = ? OR $colAddress = ?',
          [note.name, note.phone, note.address]);
    // 'SELECT * FROM $driverTable WHERE $colId = $id OR $colName = ${note.name} OR $colPhone = ${note.phone} OR $colAddress = ${note.address}
    int count =
        noteMapList.length; // Count the number of map entries in db table
    List<Driver> driverList = List<Driver>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      driverList.add(Driver.fromMapObject(noteMapList[i]));
    }
    return driverList;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Driver>> getDriverList() async {
    var noteMapList = await getDriverMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table
    List<Driver> driverList = List<Driver>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      driverList.add(Driver.fromMapObject(noteMapList[i]));
    }

    return driverList;
  }
}
