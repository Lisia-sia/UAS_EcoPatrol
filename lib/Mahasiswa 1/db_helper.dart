import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ReportModel {
  final int? id;
  final String title;
  final String description;
  final String imagePath;
  final String latitude;
  final String longitude;
  final int status; // 0 = Pending, 1 = Selesai
  final String? completionNote;
  final String? completionImage;

  ReportModel({
    this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    this.status = 0,
    this.completionNote,
    this.completionImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'completionNote': completionNote,
      'completionImage': completionImage,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      imagePath: map['imagePath'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      status: map['status'],
      completionNote: map['completionNote'],
      completionImage: map['completionImage'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ecopatrol.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE reports (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description TEXT,
      imagePath TEXT,
      latitude TEXT,
      longitude TEXT,
      status INTEGER,
      completionNote TEXT,
      completionImage TEXT
    )
    ''');
  }

  Future<int> create(ReportModel report) async {
    final db = await instance.database;
    return await db.insert('reports', report.toMap());
  }

  Future<List<ReportModel>> readAllReports() async {
    final db = await instance.database;
    final result = await db.query('reports', orderBy: 'id DESC');
    return result.map((json) => ReportModel.fromMap(json)).toList();
  }

  Future<int> update(ReportModel report) async {
    final db = await instance.database;
    return await db.update('reports', report.toMap(), where: 'id = ?', whereArgs: [report.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('reports', where: 'id = ?', whereArgs: [id]);
  }
}