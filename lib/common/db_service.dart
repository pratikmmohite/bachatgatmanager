import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DbService {
  static final DbService _instance = DbService._internal();

  int version = 1;
  late sqlite.Database db;

  factory DbService() {
    return _instance;
  }

  DbService._internal();

  Future<void> initDb() async {
    var dbPath = "app_db.sqlite";
    if (kIsWeb) {
      sqlite.databaseFactory = databaseFactoryFfiWeb;
      dbPath = "app_db.sqlite";
    }
    db = await sqlite.openDatabase(
      dbPath,
      version: version,
      onCreate: (dbC, version) async {
        await _createTables(dbC);
      },
    );
  }

  Future<List<Map<String, Object?>>> read(String sql,
      [List<Object?> parameters = const []]) async {
    var res = await db.rawQuery(sql, parameters);
    return res;
  }

  Future<int> write(String sql, [List<Object?> parameters = const []]) async {
    var updatedRows = await db.rawUpdate(sql, parameters);
    return updatedRows;
  }

  Future<int> insert(String table, Map<String, Object?> values) async {
    var updatedRows = await db.insert(table, values);
    return updatedRows;
  }

  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    var updatedRows =
        await db.update(table, values, where: where, whereArgs: whereArgs);
    return updatedRows;
  }

  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    var updatedRows =
        await db.delete(table, where: where, whereArgs: whereArgs);
    return updatedRows;
  }

  Future<void> _createTables(sqlite.Database dbC) async {
    List<String> tables = [
      '''
    CREATE TABLE groups (
    id text primary key,
    name text,
    sdt datetime,
    edt datetime,
    accountOpeningDate datetime,
    address text,
    bankName text,
    accountNo text,
    ifscCode text,
    installmentDate number,
    installmentAmt number,
    loanInterestPer number,
    loanPenaltyAmt number,
    installmentPenaltyAmt number,
    sysCreated datetime,
    sysUpdated datetime
    );
  ''',
      '''
    CREATE TABLE members (
    id text primary key,
    name text,
    mobileNo text,
    joiningDate datetime,
    groupId text,
    aadharNo text,
    panNo text,
    openingBalance number,
    sysCreated datetime,
    sysUpdated datetime,
     FOREIGN KEY(groupId) REFERENCES groups(ID)
    );
  ''',
    ];
    for (int i = 0; i < tables.length; i++) {
      await dbC.execute(tables[i]);
    }
  }
}
