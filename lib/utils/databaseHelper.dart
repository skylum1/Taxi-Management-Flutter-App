import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:taxi/models/booking.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String bookingTable = 'booking_table';
  String colId = 'id';
  String colTaxiId = 'taxiId';
  String colDestination = 'destination';
  String colSource = 'source';
  String colClientId = 'clientId';
  String colAmount = 'amount';
  String colDate = 'date';

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
    var result = await _database.query('sqlite_master',
        where: 'name = ?', whereArgs: ['$bookingTable']);
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
        'CREATE TABLE $bookingTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colClientId INTEGER, $colTaxiId INTEGER NULL, '
        '$colDestination TEXT, $colAmount INTEGER, $colDate TEXT, $colSource TEXT, FOREIGN KEY ($colTaxiId) REFERENCES taxi_table (id))');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(bookingTable, orderBy: '$colId ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(bookingTable, note.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateNote(Note note) async {
    var db = await this.database;
    var result = await db.update(bookingTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $bookingTable WHERE $colId = $id');
    return result;
  }

  Future<List<int>> getavailabletaxi({String date}) async {
    String taxiTable = 'taxi_table';
    List<int> temp = List<int>();
    if (date == '' || date == null) {
      temp.add(0);
      return temp;
    }
    Database db = await this.database;
    var x = await db.rawQuery(
        'SELECT  $taxiTable.id from $taxiTable  WHERE  available = 1 AND $taxiTable.id NOT IN (SELECT $colTaxiId from $bookingTable WHERE $colDate = ?)',
        [date]);
    //var x = await db.rawQuery(
    // 'SELECT  $taxiTable.id from $taxiTable LEFT JOIN $bookingTable ON $taxiTable.id=$bookingTable.id WHERE NOT $colDate = $date AND available = 1');
    for (int i = 0; i < x.length; i++) {
      temp.add(x[i]['id']);
    }
    return temp;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $bookingTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> searchExpense(Note note, {int id}) async {
    Database db = await this.database;
    var noteMapList;
    if (id != null)
      noteMapList = await db.rawQuery(
          'SELECT * FROM $bookingTable WHERE $colId = ? OR $colAmount = ? OR $colDate = ? OR $colDestination = ? OR $colTaxiId = ? OR $colClientId = ? OR $colSource = ?',
          [
            id,
            note.amount,
            note.date,
            note.destination,
            note.taxiId,
            note.clientId,
            note.source
          ]);
    //await db.rawQuery('SELECT * FROM $driverTable WHERE $colId = $id');
    else
      noteMapList = await db.rawQuery(
          'SELECT * FROM $bookingTable WHERE $colAmount = ? OR $colDate = ? OR $colDestination = ? OR $colTaxiId = ? OR $colClientId = ? OR $colSource = ?',
          [
            note.amount,
            note.date,
            note.destination,
            note.taxiId,
            note.clientId,
            note.source
          ]);
    // 'SELECT * FROM $driverTable WHERE $colId = $id OR $colName = ${note.name} OR $colPhone = ${note.phone} OR $colAddress = ${note.address}
    int count =
        noteMapList.length; // Count the number of map entries in db table
    List<Note> driverList = List<Note>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      driverList.add(Note.fromMapObject(noteMapList[i]));
    }
    return driverList;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<Note> noteList = List<Note>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }
}
