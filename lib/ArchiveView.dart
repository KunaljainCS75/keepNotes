import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_notez/ArchiveSection.dart';
import 'package:keep_notez/colors.dart';
import 'package:keep_notez/model/MyNoteModel.dart';
import 'package:keep_notez/services/NotesDatabase.dart';
import 'package:keep_notez/services/firebase_Database.dart';

import 'NotesView.dart';
import 'home.dart';

class ArchiveView extends StatefulWidget {
  Note note;
  ArchiveView({required this.note});

  @override
  State<ArchiveView> createState() => _ArchiveViewState();
}

class _ArchiveViewState extends State<ArchiveView> {
  late TextEditingController _controller;
  late TextEditingController _Titlecontroller;
  Timer? _debounceTimer;

  late String _selectedItem;

  late bool isPinned;
  late bool isArchived;

  @override
  void initState() {
    super.initState();
    isPinned = widget.note.pin;
    isArchived = widget.note.isArchive;

    print("pin: ${widget.note.pin}");
    print("archive: ${widget.note.isArchive}");

    // Initialize controller with some text
    _Titlecontroller = TextEditingController(text: widget.note.title);
    _controller = TextEditingController(text: widget.note.content);

    // Listen to changes in the text field and trigger autosave
    // _Titlecontroller.addListener(_onTextChanged);
    // _controller.addListener(_onTextChanged);
  }

  // void _onTextChanged() {
  //   // Cancel previous timer
  //   _debounceTimer?.cancel();
  //   // Start a new timer for autosave
  //   _debounceTimer = Timer(Duration(seconds: 1), () {
  //     _saveNote();
  //   });
  // }

  // void _saveNote() {
  //   // Save the text
  //   widget.note.content = _controller.text;
  //   widget.note.title = _Titlecontroller.text;
  //   NotesDatabase.instance.updateNotes(widget.note);
  //   print(widget.note.title);
  //   print(widget.note.content);
  //   // Here you can implement your logic to save the note to a database or file
  // }

  @override
  void dispose() {
    // Dispose the controller and timer to prevent memory leaks
    // _Titlecontroller.removeListener(_onTextChanged);
    // _controller.removeListener(_onTextChanged);
    _Titlecontroller.dispose();
    _controller.dispose();

    _debounceTimer?.cancel();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
                      () =>  {NotesDatabase.instance.deleteNote(widget.note), FireDB().deleteNoteFirebase(widget.note)});
                },
              ),
            ],
          ),
        );
      },
    );
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
          color: NotesDatabase.instance.intToColor(widget.note.color),
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

    if (widget.note.color == intColor) {
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
              if (widget.note.color != intColor) {
                widget.note.color = intColor;
              }
            });
            NotesDatabase.instance.updateNotes(widget.note);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ArchiveView(note: widget.note)));
            _showNotesBackgroundColorMenu(context);
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
        widget.note.content = _controller.text;
        widget.note.title = _Titlecontroller.text;

        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ArchiveSection()));


        Timer(
            Duration(seconds: 1),
            () => {
                  NotesDatabase.instance.updateNotes(widget.note),
                  print(widget.note.title),
                  print(widget.note.content),
                });

        return true;
      },
      child: Scaffold(
        backgroundColor: NotesDatabase.instance.intToColor(widget.note.color),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white.withOpacity(0.8)),
          backgroundColor: NotesDatabase.instance.intToColor(widget.note.color),
          elevation: 0.0,
          actions: [
            IconButton(
                onPressed: () async {
                  setState(() {
                    widget.note.pin = !widget.note.pin;
                    isPinned = widget.note.pin;
                    NotesDatabase.instance.updateNotes(widget.note);
                  });
                  if (widget.note.pin == true){
                    _showSnackBar("Note Pinned");
                  }
                  else{
                    _showSnackBar("Note Unpinned");
                  }
                },
                icon: isPinned
                    ? Icon(Icons.push_pin_rounded)
                    : Icon(Icons.push_pin_outlined)),
            IconButton(
                onPressed: () {}, icon: Icon(Icons.notification_add_outlined)),
            IconButton(
                onPressed: () async {
                  setState(() {
                    widget.note.isArchive = !widget.note.isArchive;
                  });
                  isArchived = widget.note.isArchive;
                  NotesDatabase.instance.updateNotes(widget.note);

                  Navigator.pop(context);

                  if (isArchived == false) {
                    _showSnackBar("Note unarchived");
                  }
                  else{
                    _showSnackBar("Note archived");
                  }

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ArchiveSection()));
                },
                icon: isArchived
                    ? Icon(Icons.unarchive_outlined)
                    : Icon(Icons.archive_outlined)),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: GestureDetector(
            onTap: () {
              // Focus the text field when tapped
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Column(
                children: [
                  TextField(
                    cursorColor: Colors.white,
                    controller: _Titlecontroller,
                    maxLines: null, // Allow unlimited lines
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: GoogleFonts.kumbhSans(
                          textStyle:
                              TextStyle(color: Colors.white70, fontSize: 23)),
                    ),
                    autofocus: false, // Automatically focuses on the text field
                    style: GoogleFonts.kumbhSans(
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 23)),
                  ),
                  TextField(
                    controller: _controller,
                    maxLines: null, // Allow unlimited lines
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Note',
                      hintStyle: GoogleFonts.kumbhSans(
                          textStyle: TextStyle(color: Colors.white70)),
                    ),
                    autofocus: false, // Automatically focuses on the text field
                    style: GoogleFonts.kumbhSans(
                        textStyle: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          surfaceTintColor: NotesDatabase.instance.intToColor(widget.note.color),
          color: NotesDatabase.instance.intToColor(widget.note.color),
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
              Container(
                width: MediaQuery.of(context).size.width*0.76,


                child: Center(
                  child: Text("Created on: ${widget.note.createdTime.toString().substring(0,19)}", style: GoogleFonts.kumbhSans(
                      textStyle: TextStyle(
                          color: Colors.white.withOpacity(0.9)
                      )
                  ),),
                ),
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
