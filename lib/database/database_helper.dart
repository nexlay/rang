import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'Number.dart';


class DataBaseHelper {
  static DataBaseHelper _dataBaseHelper;
  static Database _database;

  String dataTable = 'data_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'content';
  String colExist = 'exist';

  DataBaseHelper._createInstance(); // Constructor to create an instance of DataBaseHelper

  factory DataBaseHelper() {
    if (_dataBaseHelper == null) {
      _dataBaseHelper = DataBaseHelper._createInstance(); //Execute only once
    }
    return _dataBaseHelper;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initDatabase();
    }

    return _database;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'dataNumbers.db';
    var databaseOfNumbers =
    await openDatabase(path, version: 1, onCreate: _createDb);
    return databaseOfNumbers;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $dataTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle INTEGER, $colDescription TEXT, $colExist INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getDataMapList() async {
    Database db = await this.database;
    var result = await db.query(
        dataTable); // or use var result = await database.rawQuery('SELECT * FROM $dataTable');
    return result;
  }

  Future<int> insertData(Number number) async {
    Database db = await this.database;
    var result = await db.insert(dataTable, number.toMap());
    return result;
  }

  Future<int> updateData(Number number) async {
    var db = await this.database;
    var result = await db.update(dataTable, number.toMap(),
        where: '$colId = ?', whereArgs: [number.id]);
    return result;
  }

  Future<int> deleteData(int id) async {
    var db = await this.database;
    int result =
    await db.rawDelete('DELETE FROM $dataTable WHERE $colId = $id');
    return result;
  }
  Future<int> deleteAllData() async{
    var db = await this.database;
    var result = await db.delete(dataTable);
    return result;
  }

  Future<int> getCount(Number number) async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
    await db.rawQuery('SELECT COUNT (*) from $dataTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Number>> getNumberList() async {
    var numberMapList = await getDataMapList();
    int count = numberMapList.length;
    List<Number> numberList = List<Number>();
    for (int i = 0; i < count; i++) {
      numberList.add(Number.fromMapObject(numberMapList[i]));
    }
    return numberList;
  }
}
