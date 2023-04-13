import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbController extends GetxController {
  @override
  void onInit() {
    handleOpenDb();
    super.onInit();
  }

  static Future<Database> handleOpenDb() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, 'db_jpj.db');

    final dbExist = await databaseExists(path);

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      if (!dbExist) {
        final batch = db.batch();
        handleCreateTbUsers(batch);
        handleCreateTbProfile(batch);
        handleCreateTbUsersSchedulePerDay(batch);
        handleCreateTbCheckInEmp(batch);
        handleCreateTbCheckInStokpile(batch);
        await batch.commit();
      }
    });
  }

  static Future<bool> databaseExists(String path) =>
      databaseFactory.databaseExists(path);

  static handleCreateTbUsers(Batch batch) async {
    batch.execute('''
      CREATE TABLE tb_users (
        email text primary key,
        password text,
        token text
      )
    ''');
  }

  static handleCreateTbProfile(Batch batch) async {
    batch.execute('''
      CREATE TABLE tb_profile (
        token text primary key,
        name text,
        department text
      )
    ''');
  }

  static handleCreateTbUsersSchedulePerDay(Batch batch) async {
    batch.execute('''
      CREATE TABLE tb_schedulePerDay(
        token text primary key,
        id_user integer,
        check_in text,
        check_out text,
        behavior text,
        tgl text
      )
    ''');
  }

  static handleCreateTbCheckInEmp(Batch batch) async {
    batch.execute('''
      CREATE TABLE tb_checkInEmp(
        token text primary key,
        tgl text,
        id_dept integer,      
        check_in text,
        longitude text,  
        latitude text,       
        type text,
        device text,       
        picture text,       
        is_wfh text    
      )
    ''');
  }

  static handleCreateTbCheckOutEmp(Batch batch) async {
    batch.execute('''
      CREATE TABLE tb_checkOutEmp(
        token text primary key,
        tgl text,    
        check_out text,
        longitude_out text,  
        latitude_out text,
      )
    ''');
  }

  static handleCreateTbCheckInStokpile(Batch batch) async {
    batch.execute('''
      CREATE TABLE tb_checkInStokpile(
        token text primary key,
        tgl text,
        id_stock_file text,
        check_in text,
        longitude text,  
        latitude text,
        device text,       
        picture text
      )
    ''');
  }

  static handleCreateTbCheckOutStokpile(Batch batch) async {
    batch.execute('''
      CREATE TABLE tb_checkOutStokpile(
        token text primary key,
        tgl text,
        id_stock_file text,
        check_out text,
        longitude_out text,  
        latitude_out text,
      )
    ''');
  }

  static Future<Map<String, dynamic>> createData(
    String table,
    dynamic dataMap,
  ) async {
    final db = await DbController.handleOpenDb();

    final data = dataMap;

    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.ignore);

    if (kDebugMode) {
      print('Berhasil Buat Data : ${DateTime.now()}');
    }

    await db.close();
    return data;
  }

  static Future<List<Map<String, dynamic>>> rawQuery(query) async {
    final db = await DbController.handleOpenDb();
    final result = db.rawQuery("$query");
    await db.close();
    return result;
  }

  static Future<int> rawQueryUpdate(query) async {
    final db = await DbController.handleOpenDb();
    final result = db.rawUpdate(query);
    await db.close();
    return result;
  }

  static Future<int> rawQueryDelete(query) async {
    final db = await DbController.handleOpenDb();
    final result = db.rawDelete(query);
    await db.close();
    return result;
  }
}
