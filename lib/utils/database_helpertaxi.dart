// import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:taxi/models/taxi.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String taxiTable = 'taxi_table';
  String colId = 'id';
  String colDriverId = 'driverId';
  String colLicense = 'license';
  String colAvailable = 'available';
  String colModel = 'model';
  String colCarCondition = 'carCondition';
  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    var result = await _database
        .query('sqlite_master', where: 'name = ?', whereArgs: ['$taxiTable']);
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
        'CREATE TABLE $taxiTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colDriverId INTEGER NULL, '
        '$colLicense TEXT, $colCarCondition INTEGER, $colModel TEXT, $colAvailable INTEGER, FOREIGN KEY ($colDriverId) REFERENCES driver_table (id))');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getTaxiMapList() async {
    Database db = await this.database;
//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(taxiTable, orderBy: '$colId ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertTaxi(Taxi note) async {
    Database db = await this.database;
    var result = await db.insert(taxiTable, note.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateTaxi(Taxi note) async {
    var db = await this.database;
    var result = await db.update(taxiTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteTaxi(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $taxiTable WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $taxiTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Taxi>> searchTaxi(Taxi note, {int id}) async {
    Database db = await this.database;
    var noteMapList;
    if (id != null)
      noteMapList = await db.rawQuery(
          'SELECT * FROM $taxiTable WHERE $colId = ? OR $colAvailable = ? OR $colModel = ? OR $colLicense = ? OR $colDriverId = ? OR $colCarCondition = ?',
          [
            id,
            note.available,
            note.model,
            note.license,
            note.driverId,
            note.carCondition
          ]);
    //await db.rawQuery('SELECT * FROM $driverTable WHERE $colId = $id');
    else
      noteMapList = await db.rawQuery(
          'SELECT * FROM $taxiTable WHERE $colAvailable = ? OR $colModel = ? OR $colLicense = ? OR $colDriverId = ? OR $colCarCondition = ?',
          [
            note.available,
            note.model,
            note.license,
            note.driverId,
            note.carCondition
          ]);
    // 'SELECT * FROM $driverTable WHERE $colId = $id OR $colName = ${note.name} OR $colPhone = ${note.phone} OR $colAddress = ${note.address}
    int count =
        noteMapList.length; // Count the number of map entries in db table
    List<Taxi> driverList = List<Taxi>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      driverList.add(Taxi.fromMapObject(noteMapList[i]));
    }
    return driverList;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Taxi>> getTaxiList() async {
    var noteMapList = await getTaxiMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<Taxi> noteList = List<Taxi>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Taxi.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }
}
