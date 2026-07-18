import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'krishi_social.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,

      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
      CREATE TABLE agricultural_posts (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        user_name TEXT NOT NULL,
        user_image_url TEXT,
        is_user_reviewed INTEGER NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        product_name TEXT NOT NULL,
        quantity REAL NOT NULL,
        unit TEXT NOT NULL,
        available_from TEXT NOT NULL,
        available_to TEXT NOT NULL,
        district TEXT NOT NULL,
        upazila TEXT NOT NULL,
        price_per_unit REAL,
        quality_requirement TEXT,
        description TEXT,
        image_url TEXT,
        phone TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
        }
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE agricultural_posts (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        user_name TEXT NOT NULL,
        user_image_url TEXT,
        is_user_reviewed INTEGER NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        product_name TEXT NOT NULL,
        quantity REAL NOT NULL,
        unit TEXT NOT NULL,
        available_from TEXT NOT NULL,
        available_to TEXT NOT NULL,
        district TEXT NOT NULL,
        upazila TEXT NOT NULL,
        price_per_unit REAL,
        quality_requirement TEXT,
        description TEXT,
        image_url TEXT,
        phone TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }
}
