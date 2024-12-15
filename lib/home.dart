import 'dart:async';

import 'package:flutter/material.dart';
import 'package:keep_notez/LoginInfo.dart';
import 'package:keep_notez/NotesView.dart';
import 'package:keep_notez/SearchView.dart';
import 'package:keep_notez/SideMenu.dart';
import 'package:keep_notez/colors.dart';
import 'package:keep_notez/login.dart';
import 'package:keep_notez/services/NotesDatabase.dart';
import 'package:keep_notez/services/auth.dart';
import 'package:keep_notez/services/firebase_Database.dart';
import 'CreateNotesView.dart';
import 'model/MyNoteModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  late List<Note> notesList;
  bool isLoading = true;

  late String? ImgUrl;
  bool isStaggered = true;

  // String note1 = "Every day, I am getting very healthy and stronger.";
  // String note2 = "Jay Shree Ram";

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();

    FireDB().readNoteNotes();
    // FireDB().createNoteFirebase(Note(pin: false, isArchive: false, title: "Ram", content: "yo", createdTime: DateTime.now(), color: 0));
    getAllNotes();
    Timer(const Duration(milliseconds: 1100), () {
      getAllNotes();
      NotesDatabase.instance.deleteAllEmptyNotes();}
    );
  }


  Future createEntry(Note note) async {
    await NotesDatabase.instance.create(note);
    print(note);
  }

  Future<List> getAllNotes() async {
    LocalDataSaver.getImg().then((value) {
      setState(() {
        ImgUrl = value;
      });
    });
    bool _deleted = await NotesDatabase.instance.deleteAllEmptyNotes();

    var result = await NotesDatabase.instance.readAllNotes();
    notesList = [];

    for (var element in result) {
      if (element.isArchive == false) {
        if (element.pin == true) {
          notesList.add(element);
          FireDB().updateNoteFirebase(element);
        }
      }
    }
    for (var element in result) {
      if (element.isArchive == false) {
        if (element.pin == false) {
          notesList.add(element);
          FireDB().updateNoteFirebase(element);
        }
      }
    }
    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
    if (_deleted) {
      _showSnackBar("Empty Note discarded");
    }
    return notesList;
  }

  // Future<String?> getOneNotes(int id) async {
  //   await NotesDatabase.instance.readOneNote(id);
  // }
  //
  // Future updateOneNote(Note note) async {
  //   await NotesDatabase.instance.updateNotes(note);
  // }
  //
  // Future deleteOneNote(Note note) async {
  //   await NotesDatabase.instance.deleteNote(note);
  //

  // For CreateNotesView:


  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              color: bgColor,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  Image.asset("images/img.png",
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Text("Keep Notez",
                      style: GoogleFonts.kumbhSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold))),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("Google ",
                        style: GoogleFonts.kumbhSans(
                            textStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 30,
                                fontWeight: FontWeight.bold))),
                    Text("Workspace",
                        style: GoogleFonts.kumbhSans(
                            textStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 30,
                        ))),
                  ])
                ],
              ),
            ))
        : Scaffold(
            endDrawerEnableOpenDragGesture: true,
            key: _drawerKey,
            drawer: SideMenu(
                color_Notes: Colors.blue.shade800,
                color_Archive: Colors.transparent),
            floatingActionButton: FloatingActionButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 1.0,
              child: Icon(Icons.add_outlined, size: 50, color: Colors.yellow),
              backgroundColor: cardColor,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateNotesView()));
              },
            ),
            backgroundColor: bgColor,
            body: SafeArea(
              /*wrapping a Container widget with SafeArea won't cause the Container
        to move inside the SafeArea. Instead, SafeArea ensures that its child's
        content is displayed within areas of the screen that are guaranteed to be visible on all devices.

          The SafeArea widget works by adding padding to its child to avoid overlapping with system UI elements
          like the status bar, notches, or navigation bar. It doesn't change the position or layout of
          its child widget.*/

              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 55,

                        /*MediaQuery.of(context).size.width retrieves the width of the screen.
                    The width property of the Container is set to the width of the screen, making it span the entire width horizontally.
                    The height property is set to 55, giving the Container a fixed height of 55 logical pixels.*/

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: cardColor,
                            boxShadow: [
                              BoxShadow(
                                  color: black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 3)
                            ] //pass boxshadow in list form
                            ),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                TextButton(
                                    style: ButtonStyle(
                                        overlayColor:
                                            MaterialStateColor.resolveWith(
                                                (states) =>
                                                    white.withOpacity(0.1)),
                                        shape: MaterialStateProperty.all<
                                                CircleBorder>(
                                            CircleBorder(eccentricity: 0))),
                                    onPressed: () {
                                      _drawerKey.currentState!.openDrawer();
                                    },
                                    child: Icon(
                                      Icons.menu,
                                      size: 28,
                                      color: Colors.white.withOpacity(0.9),
                                    )),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SearchView()));
                                  },
                                  child: Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width - 227,

                                    /*the Container widget can have only one child directly.
                             However, you can use other widgets like Row, Column, Stack, or even nested Containers
                             to achieve layouts with multiple children.

                             If you need to have multiple children directly under a Container-like widget,
                             you can use widgets like Column or Row to arrange them vertically or horizontally, respectively,
                             within the Container.*/

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,

                                      // For a Row, the MAIN AXIS is horizontal, and for a Column, it's vertical.
                                      // Main axis alignment determines how children are positioned along the main axis.

                                      // For a Row, the CROSS AXIS is vertical, and for a Column, it's horizontal.
                                      // Cross axis alignment determines how children are positioned along the cross axis.

                                      children: [
                                        Text(
                                          "Search your notes",
                                          style: GoogleFonts.kumbhSans(
                                            textStyle: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.9),
                                                fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                    style: ButtonStyle(
                                        overlayColor:
                                            MaterialStateColor.resolveWith(
                                                (states) =>
                                                    white.withOpacity(0.1)),
                                        shape: MaterialStateProperty.all<
                                                CircleBorder>(
                                            CircleBorder(eccentricity: 0))),
                                    onPressed: () {
                                      setState(() {
                                        isStaggered = !isStaggered;
                                      });
                                    },
                                    child: Icon(
                                      size: 28,
                                      isStaggered
                                          ? Icons.view_agenda_outlined
                                          : Icons.grid_view_outlined,
                                      color: Colors.white.withOpacity(0.9),
                                    )),
                                SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    signOut();
                                    LocalDataSaver.saveLoginData(false);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login()));
                                  },
                                  child: CircleAvatar(
                                    onBackgroundImageError:
                                        (Object, StackTrace) {
                                      print("OKAY");
                                    },
                                    backgroundImage:
                                        NetworkImage(ImgUrl.toString()),
                                    radius: 18,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.7),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: isStaggered ? StaggeredView() : Listview()),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget StaggeredView() {
    return StaggeredGridView.countBuilder(
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        shrinkWrap: true,
        itemCount: notesList.length,
        crossAxisCount: 4,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NotesView(note: notesList[index])));
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: NotesDatabase.instance
                                    .intToColor(notesList[index].color) ==
                                bgColor
                            ? Colors.grey
                            : Colors.transparent),
                    color: NotesDatabase.instance
                        .intToColor(notesList[index].color)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    notesList[index].pin? Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.push_pin_rounded, color: Colors.white.withOpacity(0.7), size: 20,),
                            Text('Pinned', style: GoogleFonts.kumbhSans(
                              textStyle: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.bold
                              )
                            ),)
                          ],
                        ),
                        SizedBox(height: 15,)
                      ],
                    ):SizedBox(width: 0,),
                    Text(
                      notesList[index].title,
                      style: GoogleFonts.kumbhSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 10),
                    Text(
                      notesList[index].content.length > 250
                          ? "${notesList[index].content.substring(0, 250)}..."
                          : notesList[index].content,
                      style: GoogleFonts.kumbhSans(
                          textStyle: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
            ));
  }

  Widget Listview() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: notesList.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NotesView(note: notesList[index])));
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color:
                      NotesDatabase.instance.intToColor(notesList[index].color) ==
                              bgColor
                          ? Colors.grey
                          : Colors.transparent),
              color: NotesDatabase.instance.intToColor(notesList[index].color)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              notesList[index].pin? Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.push_pin_rounded, color: Colors.white.withOpacity(0.7), size: 20,),
                      Text('Pinned', style: GoogleFonts.kumbhSans(
                          textStyle: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.bold
                          )
                      ),)
                    ],
                  ),
                  SizedBox(height: 15,)
                ],
              ):SizedBox(width: 0,),
              Text(
                notesList[index].title,
                style: GoogleFonts.kumbhSans(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              Text(
                notesList[index].content.length > 250
                    ? "${notesList[index].content.substring(0, 250)}..."
                    : notesList[index].content,
                style: GoogleFonts.kumbhSans(
                    textStyle: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
