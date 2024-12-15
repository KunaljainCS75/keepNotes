

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:keep_notez/model/MyNoteModel.dart';
import 'firebase_Database.dart';

import '../colors.dart';

class NotesDatabase{
  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;
  NotesDatabase._init();

  // Definition of the Constructor:
  // NotesDatabase._init(); is simply the definition of the private constructor.
  // This does not mean it's being called every time the class is used.

  // Initialization of the Static Instance:
  // static final NotesDatabase instance = NotesDatabase._init();
  // is where the constructor is actually called, creating the single instance.

  // So, the constructor NotesDatabase._init() is defined once and
  // called once to create the singleton instance.
  // This ensures that only one instance of the NotesDatabase exists,
  // and the constructor is not repeatedly invoked.


  //In Dart, the order of the class members (fields, constructors, methods)
  // in the class definition does not affect how the class is used.
  // However, for clarity and readability, it's often best to define the constructor
  // first before using it to initialize a static final instance.


  Future <Database?> get database async{
    if (_database != null) return _database;
    _database = await _initializeDB('KEEP_NOTEZ_DATABASE2.db');
    return _database;
  }

  Future <Database> _initializeDB (String filepath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }
  Future _createDB(Database db, int version) async{
    final idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    final booltype = "BOOLEAN NOT NULL";
    final texttype = "content TEXT NOT NULL";
    final colorType = "INTEGER NOT NULL";

    await db.execute('''
    CREATE TABLE ${NotesImpNames.TableName} (
      ${NotesImpNames.id} $idType,
      ${NotesImpNames.pin} $booltype,
      ${NotesImpNames.isArchive} $booltype,
      ${NotesImpNames.title} $texttype,
      ${NotesImpNames.content} $texttype,
      ${NotesImpNames.createdTime} $texttype,
      ${NotesImpNames.color} $colorType
    )
    ''');
    // Similar to:
    // await db.execute('''
    // CREATE TABLE NOTES (
    //   ID INTEGER PRIMARY KEY AUTOINCREMENT,
    //   pin BOOLEAN NOT NULL,
    //   title TEXT NOT NULL,
    //   content TEXT NOT NULL,
    //   createdTime TEXT NOT NULL
    // )
    // ''');
  }
  Future <Note?> create(Note note) async{
    final db = await instance.database;
    final id = await db!.insert(NotesImpNames.TableName, note.toJson());
    FireDB().createNoteFirebase(note, id.toString());
    return note.copy(id: id);
  }

  Future <List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBystring = '${NotesImpNames.createdTime} ASC';
    final queryResult = await db!.query(NotesImpNames.TableName, orderBy: orderBystring);
    return queryResult.map((json) => Note.fromJson(json)).toList();
  }

  Future <Note?> readOneNote(int id) async{
    final db = await instance.database;
    final map = await db!.query(NotesImpNames.TableName, columns: NotesImpNames.values,
                                         where: "${NotesImpNames.id} = ?", whereArgs: [id]);
    if (map.isNotEmpty){
      return Note.fromJson(map.first);
    }
    else{
      return null;
    }
  }

  Future updateNotes(Note note) async{
    final db = await instance.database;
    FireDB().updateNoteFirebase(note);
    return await db!.update(NotesImpNames.TableName, note.toJson(),
        where: '${NotesImpNames.id} = ?', whereArgs: [note.id]);
  }
  //
  // Future <List<Note>> readArchivedNotes() async {
  //   final db = await instance.database;
  //
  //   List<Note>  result = [];
  //
  //   final orderBystring = '${NotesImpNames.createdTime} ASC';
  //   var queryResult = await db!.query(NotesImpNames.TableName, orderBy: orderBystring);
  //
  //
  //   queryResult.forEach((element) {
  //     if (element["isArchive"] == true){
  //       result.add(element as Note);
  //     }
  //   });
  //   if (result == []){
  //     return [];
  //   }
  //   else{
  //     return result;
  //   }
  // }
  
  // Future pinNote (Note note) async{
  //   final db = await instance.database;
  //   await db!.update(NotesImpNames.TableName, {NotesImpNames.pin : !note.pin? 1: 0}, where: '${NotesImpNames.id} = ?', whereArgs: [note.id]);
  //                                                               // !True? --> False? --> is False == True --> False --> assign 0
  // }
  
  Future deleteNote (Note note) async{
    final db = await instance.database;
    FireDB().deleteNoteFirebase(note);
    await db!.delete(NotesImpNames.TableName, where: '${NotesImpNames.id} = ?', whereArgs: [note.id]);
  }


  Future <bool> deleteAllEmptyNotes () async{

    final db = await instance.database;
    final temp_result = await db!.query(NotesImpNames.TableName);
    final result = temp_result.map((json) => Note.fromJson(json)).toList();

    bool _is_deleted = false;

    //For FIREBASE Deletion
    for (var element in result) {
      if (element.title == "" && element.content == "") {
        FireDB().deleteNoteFirebase(element);
        _is_deleted = true;
      }
    }

    //For Emulator database Deletion
    if (_is_deleted) {
      db!.delete(NotesImpNames.TableName, where: '${NotesImpNames.title} = "" and ${NotesImpNames.content} = ""');
    }
    return _is_deleted;
  }
  
  Future <List<int>> getNoteStringforSearch (String query) async{

    final db = await instance.database;
    final result = await db!.query(NotesImpNames.TableName);

    List <int> resultIDs = [];

    result.forEach((element) {
      if(element["title"].toString().toLowerCase().contains(query)
      || element["content"].toString().toLowerCase().contains(query)) {
        resultIDs.add(element["id"] as int);
      }
    });
    return resultIDs;
  }

  Future closeDB() async{
    final db = await instance.database;
    db?.close();
  }
  final Map<int, Color> colorMap = {
    0: bgColor,
    1: Colors.pink.shade900,
    2: Colors.deepOrange.shade900,
    3: Colors.lime.shade900,
    4: Colors.teal.shade900,
    5: Colors.indigo.shade800,
    6: Colors.purple.shade900,
    7: Colors.black54
    // Add more colors as needed
  };

  Color? intToColor(int colorCode) {
    return colorMap[colorCode];
  }
}