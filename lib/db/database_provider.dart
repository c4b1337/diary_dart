import 'package:flutter_application_1/model/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class ISqliteRepo {
  Future<int> addNewNote({String? title, String? body});
  Future<int> dropNote({required NoteModel note});
  Future<List<NoteModel>> fetchAllNotes();
  Future<int> dropAll();
}

class SqliteServiceImp implements ISqliteRepo {
  static const String table = 'notes';
  SqliteServiceImp() {
    init();
  }
  Future<Database> init() async {
    final String dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'note_app.db'),
      onCreate: (database, version) async {
        await database.execute(
          """
        CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        body TEXT,
        creation_date INTEGER
        )
          """,
        );
      },
      version: 1,
    );
  }

  @override
  Future<int> addNewNote({String? title, String? body}) async {
    final db = await init();
    return await db.insert(table,
        {'title': title, 'body': body, 'creation_date': DateTime.now().millisecondsSinceEpoch},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<NoteModel>> fetchAllNotes() async {
    final db = await init();
    final res = await db.query(table);
    return List<NoteModel>.from(res.map((e) => NoteModel.fromMap(e)));
  }

  @override
  Future<int> dropNote({required NoteModel note}) async {
    final db = await init();
    return await db.delete(table, where: 'id =?', whereArgs: [note.id]);
  }

  @override
  Future<int> dropAll() async {
    final db = await init();
    return await db.delete(table);
  }
}
