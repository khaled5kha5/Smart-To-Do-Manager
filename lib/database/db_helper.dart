import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class SQLDatabase{

  static final SQLDatabase instance = SQLDatabase.init();
  Database? _database;
  SQLDatabase.init();
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initializedatabase();
    return _database!;
  }

Future <Database> initializedatabase() async {
  String dbPath = await getDatabasesPath();
  String path = join(dbPath, 'tasks.db');

  return openDatabase(
    path,
    version: 1,
    onCreate: _onCreate,
  );


}
Future<void> _onCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE tasks(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description TEXT,
      priority TEXT,
      dueDate TEXT,
      isCompleted INTEGER
    )
  ''');

}

Future<int> insertTask(Map<String, dynamic> task) async {
  final db = await instance.database;
  return await db.insert('tasks', task);


}
Future<List<Task>> getTasks() async {
  final db = await instance.database;
  final result = await db.query('tasks');

  return result.map((map) => Task.fromMap(map)).toList();
}
Future<int> updateTask(Map<String, dynamic> task) async {
  final db = await instance.database;
  return await db.update(
    'tasks',
    task,
    where: 'id = ?',
    whereArgs: [task['id']],
  );
}
Future<int> deleteTask(int id) async {
  final db = await instance.database;
  return await db.delete(
    'tasks',
    where: 'id = ?',
    whereArgs: [id],
  );
}
}