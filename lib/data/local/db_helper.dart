import 'dart:async';
import 'dart:io';



import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  // make singleton
  // private constructor
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();
  static final String tableNoteName = 'noteData';
  static final String coloumnNoteSNo = 'sno';
  static final String coloumnNoteTitle = 'title';
  static final String coloumnNoteDesc = 'desc';


  Database? myDB;

// get database
  Future<Database> getDb() async {
    myDB ??= await openDb();
    return myDB!;
  }

  // open database
  Future<Database> openDb() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String rootPath = appDirectory.path;
    String dbPath = join(rootPath, 'notes.db');

    return await openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.rawQuery(
          'create table $tableNoteName ( $coloumnNoteSNo integer primary key autoincrement, $coloumnNoteTitle text, $coloumnNoteDesc text)');
    });
  }

  // queries
// insert notes query
  Future<bool> addNote({ required String title, required String desc}) async {
    var db = await getDb();
    int rowsEffected = await db.insert(tableNoteName, {
      coloumnNoteTitle: title,
      coloumnNoteDesc: desc
    });
    return rowsEffected > 0;
  }

// get notes query
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDb();
    var allNotes = await db.query(tableNoteName);
    return allNotes;
  }

// Update Notes
  Future<bool> updateNote(
      {required String title, required String desc, required int sno}) async {
    var db = await getDb();
    int rowsEffected = await db.update(tableNoteName,
        {coloumnNoteTitle: title,
          coloumnNoteDesc: desc
        }, where: "$coloumnNoteSNo = $sno");
    return rowsEffected > 0;
  }

// delete notes
}