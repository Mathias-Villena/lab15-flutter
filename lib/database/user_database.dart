import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

class UserDatabase {
  static final UserDatabase instance = UserDatabase._internal();
  static Database? _database;

  UserDatabase._internal();

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
      CREATE TABLE ${UserFields.tableName} (
        ${UserFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${UserFields.email} TEXT NOT NULL UNIQUE,
        ${UserFields.password} TEXT NOT NULL,
        ${UserFields.fullName} TEXT NOT NULL
      )
    ''');

    // Tabla de citas
    await db.execute('''
      CREATE TABLE appointments (
        _id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        patient_name TEXT NOT NULL,
        doctor_name TEXT NOT NULL,
        date TEXT NOT NULL,
        notes TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES ${UserFields.tableName}(${UserFields.id})
      )
    ''');
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Agregar user_id a la tabla existente
      await db.execute(
          'ALTER TABLE appointments ADD COLUMN user_id INTEGER DEFAULT 1');
    }
  }

  // ===== MÉTODOS DE USUARIO =====

  /// Registrar nuevo usuario
  Future<UserModel?> register(
      String email, String password, String fullName) async {
    try {
      final db = await database;
      final id = await db.insert(UserFields.tableName, {
        UserFields.email: email,
        UserFields.password: password,
        UserFields.fullName: fullName,
      });
      return UserModel(
        id: id,
        email: email,
        password: password,
        fullName: fullName,
      );
    } catch (e) {
      // Email ya existe o error en BD
      return null;
    }
  }

  /// Login - valida email y contraseña
  Future<UserModel?> login(String email, String password) async {
    final db = await database;
    final result = await db.query(
      UserFields.tableName,
      where: '${UserFields.email} = ? AND ${UserFields.password} = ?',
      whereArgs: [email, password],
    );

    if (result.isEmpty) return null;
    return UserModel.fromJson(result.first);
  }

  /// Obtener usuario por email
  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      UserFields.tableName,
      where: '${UserFields.email} = ?',
      whereArgs: [email],
    );

    if (result.isEmpty) return null;
    return UserModel.fromJson(result.first);
  }

  /// Obtener usuario por ID
  Future<UserModel?> getUserById(int id) async {
    final db = await database;
    final result = await db.query(
      UserFields.tableName,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;
    return UserModel.fromJson(result.first);
  }

  /// Obtener todos los usuarios (para debugging)
  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final result = await db.query(UserFields.tableName);
    return result.map((e) => UserModel.fromJson(e)).toList();
  }

  /// Eliminar usuario
  Future<int> deleteUser(int id) async {
    final db = await database;
    return db.delete(
      UserFields.tableName,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );
  }
}
