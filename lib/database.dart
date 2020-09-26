import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bank_account_storage/models/account.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "accounts_1.sqlite");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE accounts (id INTEGER PRIMARY KEY, title TEXT, value TEXT, color TEXT)");
    });
  }

  newAccount(Account newAccount) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id) + 1 as id FROM accounts");
    int id = table.first["id"];
    var raw = await db.rawInsert(
        "INSERT Into accounts (id,title,value,color) VALUES (?,?,?,?)",
        [id, newAccount.title, newAccount.value, newAccount.color]);
    return raw;
  }

  updateAccount(Account newAccount) async {
    final db = await database;
    var res = await db.update("accounts", newAccount.toMap(),
        where: "id = ?", whereArgs: [newAccount.id]);
    return res;
  }

  getAccount(int id) async {
    final db = await database;
    var res = await db.query("accounts", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Account.fromMap(res.first) : null;
  }

  Future<List<Account>> getAccountList() async {
    final db = await database;
    var res = await db.query("accounts DESC");
    List<Account> list =
        res.isNotEmpty ? res.map((c) => Account.fromMap(c)).toList() : [];
    return list;
  }

  deleteAccount(int id) async {
    final db = await database;
    return db.delete("accounts", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("delete * from accounts");
  }
}
