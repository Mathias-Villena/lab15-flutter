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
      version: 2,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Tabla de usuarios
    await db.execute('''
      CREATE TABLE users (
        _id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        full_name TEXT NOT NULL
      )
    ''');

    // Tabla de citas con user_id
    await db.execute('''
      CREATE TABLE ${AppointmentFields.tableName} (
        ${AppointmentFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppointmentFields.userId} INTEGER NOT NULL,
        ${AppointmentFields.patientName} TEXT NOT NULL,
        ${AppointmentFields.doctorName} TEXT NOT NULL,
        ${AppointmentFields.date} TEXT NOT NULL,
        ${AppointmentFields.notes} TEXT NOT NULL,
        FOREIGN KEY (${AppointmentFields.userId}) REFERENCES users(_id)
      )
    ''');
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Agregar tabla de usuarios
      await db.execute('''
        CREATE TABLE users (
          _id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL,
          full_name TEXT NOT NULL
        )
      ''');
      // Agregar columna user_id a appointments
      await db.execute(
          'ALTER TABLE ${AppointmentFields.tableName} ADD COLUMN ${AppointmentFields.userId} INTEGER DEFAULT 1');
    }
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

  /// Obtener citas solo del usuario autenticado
  Future<List<AppointmentModel>> readAllByUser(int userId) async {
    final db = await database;

    final result = await db.query(
      AppointmentFields.tableName,
      where: '${AppointmentFields.userId} = ?',
      whereArgs: [userId],
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
