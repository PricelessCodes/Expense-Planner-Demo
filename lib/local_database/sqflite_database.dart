import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class SqfliteDatabase {
  static Future<sql.Database> database(String table) async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, table),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $table (id TEXT PRIMARY KEY, title TEXT, amount REAL, dateTime Text)');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getDatebase(String table) async {
    final db = await database(table);
    return db.query(table);
  }

  static Future<int> insert(String table, Map<String, Object> data) async {
    final db = await database(table);
    return await db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<int> delete(String table, String txId) async {
    final db = await database(table);
    return await db.rawDelete('DELETE FROM $table WHERE id = "$txId"');
  }
}
