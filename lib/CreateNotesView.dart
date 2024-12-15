import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_notez/NotesView.dart';
import 'package:keep_notez/colors.dart';
import 'package:keep_notez/services/NotesDatabase.dart';

import 'ArchiveView.dart';
import 'home.dart';
import 'model/MyNoteModel.dart';

class CreateNotesView extends StatefulWidget {


  @override
  State<CreateNotesView> createState() => _CreateNotesViewState();
}

class _CreateNotesViewState extends State<CreateNotesView> {

  late TextEditingController _ContentController;
  late TextEditingController _TitleController;

  Note note = Note(title: "", content: "", createdTime: DateTime.now(), pin: false, isArchive: false, color: 0);


  Timer? _debounceTimer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _TitleController = TextEditingController(text: note.title);
    _ContentController = TextEditingController(text: note.content);

    _TitleController.addListener(_onTextChanged);
    _ContentController.addListener(_onTextChanged);

    NotesDatabase.instance.deleteAllEmptyNotes();
  }

  void _onTextChanged(){
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(seconds: 1), (){
      _saveNote();
    });
  }

  void _saveNote(){
    note.title = _TitleController.text;
    note.content = _ContentController.text;
    NotesDatabase.instance.updateNotes(note);

    print(note.title);
    print(note.content);
  }
  void dispose() {
    // Dispose the controller and timer to prevent memory leaks
    _TitleController.removeListener(_onTextChanged);
    _ContentController.removeListener(_onTextChanged);

    if (note.content != "" || note.title != ""){
      NotesDatabase.instance.create(note);
    }

    _TitleController.dispose();
    _ContentController.dispose();

    _debounceTimer?.cancel();
    super.dispose();
  }

  void _showMoreOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height:
          MediaQuery.of(context).size.height * 0.09, // 25% of screen height
          color: bgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.delete_outline_outlined,
                  color: Colors.white.withOpacity(0.8),
                ),
                title: Text(
                  'Delete',
                  style: GoogleFonts.kumbhSans(
                      textStyle:
                      TextStyle(color: Colors.white.withOpacity(0.7))),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar('Deleted selected note');
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));

                  Timer(const Duration(seconds: 1),
                          () => {NotesDatabase.instance.deleteNote(note)});
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  //
  // void toggleCheck() {
  //   setState(() {
  //     ischecked = !ischecked;
  //   });
  // }

  void _showNotesBackgroundColorMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          color: NotesDatabase.instance.intToColor(note.color),
          height:
          MediaQuery.of(context).size.height * 0.25, // 25% of screen height
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Color',
                  style: GoogleFonts.kumbhSans(
                      textStyle: TextStyle(color: Colors.white, fontSize: 15))),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _colors(0),
                    _colors(1),
                    _colors(2),
                    _colors(3),
                    _colors(4),
                    _colors(5),
                    _colors(6),
                    _colors(7)
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _colors(int intColor) {

    bool ischecked = false;
    bool istransparent = false;

    if (note.color == intColor) {
      ischecked = true;
    }
    if (intColor == 0){
      istransparent = true;
    }

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (note.color != intColor) {
                note.color = intColor;
              }
            });
            NotesDatabase.instance.updateNotes(note);
          },
          child: Stack(
            children: [
              Container(
                width: 50, // radius + border width * 2
                height: 70, // radius + border width * 2
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white70, // border color
                    width: 0.5, // border width
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: NotesDatabase.instance.intToColor(intColor),
                  radius: 50,
                ),
              ),
              istransparent? Positioned(
                  bottom: 10,
                  child: ischecked
                      ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.indigo[200],
                      size: 47,
                    ) ,
                  ) : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.not_interested,
                      color: Colors.indigo[200],
                      size: 51,
                    ) ,
                  )
              ): Positioned(
                bottom: 10,
                child: ischecked
                    ? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 47,
                  ) ,
                )
                    : Container(),
              ),

            ],
          ),
        ),
        SizedBox(width: 17),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
        return true;
      },
      child: Scaffold(
        backgroundColor: NotesDatabase.instance.intToColor(note.color),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: NotesDatabase.instance.intToColor(note.color),
          elevation: 0.0,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.push_pin_outlined)),
            IconButton(
                onPressed: () {}, icon: Icon(Icons.notification_add_outlined)),
            IconButton(onPressed: () {}, icon: Icon(Icons.archive_outlined)),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            // Focus the text field when tapped
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(

            margin: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Column(
              children: [
                TextField(
                  textInputAction: TextInputAction.done,
                  controller: _TitleController,
                  cursorColor: Colors.white,
                  maxLines: null, // Allow unlimited lines
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                    hintStyle: GoogleFonts.kumbhSans(
                        textStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 23
                        )
                    ),
                  ),
                  style: GoogleFonts.kumbhSans(
                      textStyle: TextStyle(
                          color: Colors.white, fontSize: 23
                      )
                  ),
                ),
                TextField(
                  textInputAction: TextInputAction.done,
                  controller: _ContentController,
                  maxLines: null, // Allow unlimited lines
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Note',
                    hintStyle: GoogleFonts.kumbhSans(
                        textStyle: TextStyle(
                            color: Colors.grey
                        )
                    ),
                  ),
                  style: GoogleFonts.kumbhSans(
                      textStyle: TextStyle(
                          color: Colors.white
                      )
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          surfaceTintColor: NotesDatabase.instance.intToColor(note.color),
          color: NotesDatabase.instance.intToColor(note.color),
          height: 60,
          padding: EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    _showNotesBackgroundColorMenu(context);
                  },
                  icon: Icon(
                    Icons.palette_outlined,
                    color: Colors.white.withOpacity(0.8),
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.765,
              ),
              IconButton(
                  onPressed: () {
                    _showMoreOptionsMenu(context);
                  },
                  icon: Icon(
                    Icons.more_vert_outlined,
                    color: Colors.white.withOpacity(0.8),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}