import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'item.dart';
import 'itemcard.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;
  DbHelper._createObject();
  Future<Database> initDb() async {
    //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'itemprofile.db' + 'itemcard.db';
    //create, read databases
    var itemDatabase = openDatabase(path, version: 5, onCreate: _createDb);
    //mengembalikan nilai object sebagai hasil dari fungsinya
    return itemDatabase;
  }

  //buat tabel baru dengan nama item
  void _createDb(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
      CREATE TABLE itemprofile (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      code TEXT,
      phone INTEGER,
      address TEXT
      )
    ''');
    batch.execute('''CREATE TABLE itemcard (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      code TEXT
      )''');
    await batch.commit();
  }

//select databases
  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.initDb();
    var mapList = await db.query('itemprofile', orderBy: 'name');
    return mapList;
  }

  //select databases
  Future<List<Map<String, dynamic>>> selectcard() async {
    Database db = await this.initDb();
    var mapList = await db.query('itemcard', orderBy: 'name');
    return mapList;
  }

  //create databases
  Future<int> insert(ItemProfile object) async {
    Database db = await this.initDb();
    int count = await db.insert('itemprofile', object.toMap());
    return count;
  }

  //create databases
  Future<int> insertcard(ItemCard object) async {
    Database db = await this.initDb();
    int count = await db.insert('itemcard', object.toMap());
    return count;
  }

  //update databases
  Future<int> update(ItemProfile object) async {
    Database db = await this.initDb();
    int count = await db.update('itemprofile', object.toMap(),
        where: 'id=?', whereArgs: [object.id]);
    return count;
  }

  //update databases
  Future<int> updatecard(ItemCard object) async {
    Database db = await this.initDb();
    int count = await db.update('itemcard', object.toMap(),
        where: 'id=?', whereArgs: [object.id]);
    return count;
  }

  //delete databases
  Future<int> delete(int id) async {
    Database db = await this.initDb();
    int count = await db.delete('itemprofile', where: 'id=?', whereArgs: [id]);
    return count;
  }

  //delete databases
  Future<int> deletecard(int id) async {
    Database db = await this.initDb();
    int count = await db.delete('itemcard', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<ItemProfile>> getItemList() async {
    var itemMapList = await select();
    int count = itemMapList.length;
    List<ItemProfile> itemList = List<ItemProfile>();
    for (int i = 0; i < count; i++) {
      itemList.add(ItemProfile.fromMap(itemMapList[i]));
    }
    return itemList;
  }

  Future<List<ItemCard>> getItemListcard() async {
    var itemMapList = await selectcard();
    int count = itemMapList.length;
    List<ItemCard> itemListcard = List<ItemCard>();
    for (int i = 0; i < count; i++) {
      itemListcard.add(ItemCard.fromMap(itemMapList[i]));
    }
    return itemListcard;
  }

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }
}
