import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/appointment.dart';

class AppointmentDatabase {
  static final AppointmentDatabase instance = AppointmentDatabase._internal();
  static Database? _database;

  AppointmentDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'appointments.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppointmentFields.tableName} (
        ${AppointmentFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppointmentFields.patientName} TEXT NOT NULL,
        ${AppointmentFields.doctorName} TEXT NOT NULL,
        ${AppointmentFields.date} TEXT NOT NULL,
        ${AppointmentFields.notes} TEXT NOT NULL
      )
    ''');
  }

  Future<AppointmentModel> create(AppointmentModel appt) async {
    final db = await database;
    final id = await db.insert(AppointmentFields.tableName, appt.toJson());
    return appt.copy(id: id);
  }

  Future<List<AppointmentModel>> readAll() async {
    final db = await database;

    final result = await db.query(
      AppointmentFields.tableName,
      orderBy: '${AppointmentFields.date} DESC',
    );

    return result.map((e) => AppointmentModel.fromJson(e)).toList();
  }

  Future<int> update(AppointmentModel appt) async {
    final db = await database;
    return db.update(
      AppointmentFields.tableName,
      appt.toJson(),
      where: '${AppointmentFields.id} = ?',
      whereArgs: [appt.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return db.delete(
      AppointmentFields.tableName,
      where: '${AppointmentFields.id} = ?',
      whereArgs: [id],
    );
  }
}
