import 'package:flutter/material.dart';

class NotesImpNames{
  static final String id = "id";
  static final String pin = 'pin';
  static final String title = 'title';
  static final String content = 'content';
  static final String createdTime = 'createdTime';
  static final String isArchive = "isArchive";
  static final String color = "color";
  static final List<String> values = [id, pin, isArchive, title, content, createdTime, color];
  static final String TableName = "NOTES_Table";
}

class Note{
  //       ID INTEGER PRIMARY KEY AUTOINCREMENT,
  //       pin BOOLEAN NOT NULL,
  //       title TEXT NOT NULL,
  //       content TEXT NOT NULL,
  //       createdTime TEXT NOT NULL
  final int? id;    //? question mark make datatype nullable type
  bool pin;
  bool isArchive;
  String title;
  String content;
  final DateTime createdTime;
  int color;

  Note({
    this.id,
    required this.pin,
    required this.isArchive,
    required this.title,
    required this.content,
    required this.createdTime,
    required this.color
  });

  Note copy({
    int? id,
    bool? pin,
    bool? isArchive,
    String? title,
    String? content,
    DateTime? createdTime,
    int? color
}){
    return Note(id : id?? this.id, pin: pin?? this.pin, isArchive: isArchive?? this.isArchive,
                title: title?? this.title, content:content?? this.content,
                createdTime: createdTime?? this.createdTime,
                color: color?? this.color);
  }
  //
  // final Map<String, Color> colorMap = {
  //
  //   'Colors.red': Colors.red,
  //   'Colors.green': Colors.green,
  //   'Colors.blue': Colors.blue,
  //   'Colors.yellow': Colors.yellow,
  //   'Colors.orange': Colors.orange,
  //   'Colors.purple': Colors.purple,
  //   'Colors.pink': Colors.pink,
  //   'Colors.black': Colors.black,
  //   'Colors.white': Colors.white,
  //   'Colors.grey': Colors.grey,
  //   'Colors.brown': Colors.brown,
  //   'Colors.cyan': Colors.cyan,
  //   'Colors.lime': Colors.lime,
  //   'Colors.indigo': Colors.indigo,
  //   // Add more colors as needed
  // };
  //
  // Color? stringToColor(String colorString) {
  //   if (colorMap[colorString] == null){
  //     return Colors.transparent;
  //   }
  //   else{
  //     return colorMap[colorString];
  //   }
  // }

  static Note fromJson(Map<String, Object?> json){ //JSON-STRING to MAP

    return Note(id: json[NotesImpNames.id] as int?,
                pin: json[NotesImpNames.pin] == 1,
                isArchive: json[NotesImpNames.isArchive] == 1,
                title: json[NotesImpNames.title] as String,
                content: json[NotesImpNames.content] as String,
                createdTime: DateTime.parse(json[NotesImpNames.createdTime] as String),
                color: json[NotesImpNames.color] as int
                );

    // this method takes a JSON map, extracts the relevant fields,
    // converts them to the appropriate types, and then uses these fields
    // to construct and return a Note object.
    // This is a common pattern for deserializing JSON data into a Dart object.


    // JSON MAP --- Keys are always "STRING" with values of any type..
    // Regular MAP --- Keys and values can be of any type except

    // MAP TO JSON-STRING ---> (MAP - JSON) ---> Serialization:
    // String jsonString = jsonEncode(map);

    // JSON-STRING to MAP --> (JSON - MAP) ----> Deserialization:
    // Map<String, dynamic> map = jsonDecode(jsonString);
  }

  Map<String,Object?> toJson(){ // MAP to JSON-STRING
    return{
      NotesImpNames.id : id,
      NotesImpNames.pin : pin? 1 : 0,
      NotesImpNames.isArchive : isArchive? 1 : 0,
      NotesImpNames.title : title,
      NotesImpNames.content : content,
      NotesImpNames.createdTime : createdTime.toIso8601String(),
      NotesImpNames.color : color
    };
  }
}
