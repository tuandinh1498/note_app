import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../data/model/note_model.dart';
import '../const/db_key.dart';


class DbHelper {

  static Database? _database;

   Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DbKeys.db);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DbKeys.dbTable} (
        ${DbKeys.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbKeys.title} TEXT,
        ${DbKeys.note} TEXT,
        ${DbKeys.date} TEXT,
        ${DbKeys.time} TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DbKeys.dbRemind} (
        ${DbKeys.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbKeys.title} TEXT,
        ${DbKeys.note} TEXT,
        ${DbKeys.date} TEXT,
        ${DbKeys.time} TEXT
      )
    ''');
  }

  Future<int> addTask(NoteModel task) async {
    final db = await database;
    return db.transaction((txn) async {
      return await txn.insert(
        DbKeys.dbTable,
        task.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<List<NoteModel>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      DbKeys.dbTable,
      orderBy: "id DESC",
    );
    return List.generate(
      maps.length,
          (index) {

        return NoteModel.fromJson(maps[index]);
      },
    );
  }

  Future<int> updateTask(NoteModel task) async {
    final db = await database;
    return db.transaction((txn) async {
      return await txn.update(
        DbKeys.dbTable,
        task.toJson(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    });
  }

  Future<int> deleteTask(NoteModel task) async {
    final db = await database;
    return db.transaction(
          (txn) async {
        return await txn.delete(
          DbKeys.dbTable,
          where: 'id = ?',
          whereArgs: [task.id],
        );
      },
    );
  }


  Future<int> addRemind(NoteModel task) async {
    final db = await database;
    return db.transaction((txn) async {
      return await txn.insert(
        DbKeys.dbRemind,
        task.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<List<NoteModel>> getAllReminds() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      DbKeys.dbRemind,
      orderBy: "id DESC",
    );
    return List.generate(
      maps.length,
          (index) {

        return NoteModel.fromJson(maps[index]);
      },
    );
  }

  Future<int> updateRemind(NoteModel task) async {
    final db = await database;
    return db.transaction((txn) async {
      return await txn.update(
        DbKeys.dbRemind,
        task.toJson(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    });
  }

  Future<int> deleteRemind(NoteModel task) async {
    final db = await database;
    return db.transaction(
          (txn) async {
        return await txn.delete(
          DbKeys.dbRemind,
          where: 'id = ?',
          whereArgs: [task.id],
        );
      },
    );
  }
}

