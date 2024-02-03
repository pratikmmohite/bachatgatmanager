import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DbService {
  static final DbService _instance = DbService._internal();

  int version = 2;
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
    db = await sqlite.openDatabase(dbPath, version: version,
        onCreate: (dbC, version) async {
      await _createTables(dbC);
    });
  }

  Future<void> closeDb() async {
    if (kIsWeb) {
      sqlite.databaseFactory = databaseFactoryFfiWeb;
    }
    db.close();
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
      installmentAmtPerMonth number,
      loanInterestPercentPerMonth number,
      lateFeePerDay number,
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
      balance number,
      active_loan number,
      sysCreated datetime,
      sysUpdated datetime,
      FOREIGN KEY(groupId) REFERENCES groups(ID)
    );
  ''',
      '''
    create table transactions (
        id text primary key,
        groupId text,
        memberId text,
        trxPeriod text,
        trxDt datetime,
        trxType text,
        cr number,
        dr number,
        sourceType text,
        sourceId text,
        addedBy text,
        note text,
        sysCreated datetime,
        sysUpdated datetime,
        FOREIGN KEY(groupId) REFERENCES groups(id),
        FOREIGN KEY(memberId) REFERENCES members(id)
    )
  ''',
      '''
    CREATE TABLE loans (
      id text primary key,
      memberId text,
      groupId text,
      loanAmount number,
      interestPercentage number,
      paidLoanAmount number,
      paidInterestAmount number,
      note text,
      status text,
      addedBy text,
      loanDate datetime,
      sysCreated datetime,
      sysUpdated datetime,
      FOREIGN KEY(groupId) REFERENCES groups(id),
      FOREIGN KEY(memberId) REFERENCES members(id)
    );
  ''',
    ];
    for (int i = 0; i < tables.length; i++) {
      await dbC.execute(tables[i]);
    }
  }
}
