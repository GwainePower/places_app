import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:path/path.dart' as path;

class DBHelper {
  // Метод ниже просто создает/открывает базу данных и возвращает её
  static Future<sqlite.Database> openDB() async {
    final dbPath = await sqlite.getDatabasesPath();
    return sqlite.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, picturePath TEXT, latitude REAL, longitude REAL, address TEXT)');
    }, version: 1);
  }

  // Метод ниже добавляет новые данные в БД
  static Future<void> insert(String table, Map<String, Object> data) async {
    final sqliteDB = await DBHelper.openDB();
    await sqliteDB.insert(
      table,
      data,
      conflictAlgorithm: sqlite.ConflictAlgorithm.replace,
    );
  }

  static Future<void> delete(String table, String id) async {
    final sqliteDB = await DBHelper.openDB();
    await sqliteDB.delete(table, where: 'id = "$id"');
  }

  // Метод ниже возвращает данные из таблицы БД
  // Перевод: Возвращаю *асинхронно* список из коллекций строк и объектов
  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final sqliteDB = await DBHelper.openDB();
    return sqliteDB.query(table);
  }
}
