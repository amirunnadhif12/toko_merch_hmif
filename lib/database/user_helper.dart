import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDataBaseHelper {
  static final _databaseName = "toko_merch.db";
  static final _databaseVersion = 2;
  UserDataBaseHelper._privateConstructor();
  static final UserDataBaseHelper instance = UserDataBaseHelper._privateConstructor();
  static Database? _database;  
  
  Future<Database> get database async {
    if (_database != null) return _database!;
      _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion, 
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Tabel User
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email VARCHAR NOT NULL,
        nama VARCHAR NOT NULL,
        password VARCHAR NOT NULL,
        telepon VARCHAR,
        alamat TEXT
      )
    ''');

    // Tabel Transaksi
    await db.execute('''
      CREATE TABLE transaksi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        nama_barang VARCHAR NOT NULL,
        harga REAL NOT NULL,
        qty INTEGER NOT NULL,
        total REAL NOT NULL,
        nama_pembeli VARCHAR NOT NULL,
        email_pembeli VARCHAR NOT NULL,
        telepon_pembeli VARCHAR NOT NULL,
        alamat_pengiriman TEXT NOT NULL,
        metode_pembayaran VARCHAR NOT NULL,
        status_pembayaran VARCHAR NOT NULL,
        tanggal_transaksi VARCHAR NOT NULL,
        FOREIGN KEY (user_id) REFERENCES user (id)
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Tambah tabel transaksi jika upgrade dari versi 1
      await db.execute('''
        CREATE TABLE IF NOT EXISTS transaksi (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          nama_barang VARCHAR NOT NULL,
          harga REAL NOT NULL,
          qty INTEGER NOT NULL,
          total REAL NOT NULL,
          nama_pembeli VARCHAR NOT NULL,
          email_pembeli VARCHAR NOT NULL,
          telepon_pembeli VARCHAR NOT NULL,
          alamat_pengiriman TEXT NOT NULL,
          metode_pembayaran VARCHAR NOT NULL,
          status_pembayaran VARCHAR NOT NULL,
          tanggal_transaksi VARCHAR NOT NULL,
          FOREIGN KEY (user_id) REFERENCES user (id)
        )
      ''');
    }
  }

  // ============ USER OPERATIONS ============
  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('user', row);
  }

  Future<Map<String, dynamic>?> queryUserByEmail(String email) async { 
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query('user',
      where: 'email = ?', 
      whereArgs: [email]);
    if(results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> queryUserById(int id) async { 
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query('user',
      where: 'id = ?', 
      whereArgs: [id]);
    if(results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  // ============ TRANSAKSI OPERATIONS ============
  Future<int> insertTransaksi(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('transaksi', row);
  }

  Future<List<Map<String, dynamic>>> queryAllTransaksi() async {
    Database db = await instance.database;
    return await db.query('transaksi', orderBy: 'id DESC');
  }

  Future<List<Map<String, dynamic>>> queryTransaksiByUserId(int userId) async {
    Database db = await instance.database;
    return await db.query('transaksi',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC');
  }

  Future<Map<String, dynamic>?> queryTransaksiById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query('transaksi',
      where: 'id = ?',
      whereArgs: [id]);
    if(results.isNotEmpty) {
      return results.first;
    }
    return null;
  }
}