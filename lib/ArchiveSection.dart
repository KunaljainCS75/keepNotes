import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_notez/ArchiveView.dart';
import 'package:keep_notez/services/NotesDatabase.dart';

import 'NotesView.dart';
import 'SearchView.dart';
import 'SideMenu.dart';
import 'colors.dart';
import 'home.dart';
import 'model/MyNoteModel.dart';

class ArchiveSection extends StatefulWidget {
  const ArchiveSection({super.key});

  @override
  State<ArchiveSection> createState() => _ArchiveSectionState();
}

class _ArchiveSectionState extends State<ArchiveSection> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  late List<Note> notesList;
  bool isLoading = true;

  bool isStaggered = true;
  

  Future<List> getArchivedNotes() async {
    var result = await NotesDatabase.instance.readAllNotes();
    notesList = [];

    for (var element in result) {
      if (element.isArchive == true) {
        notesList.add(element);
      }
    }

    setState(() {
      isLoading = false;
    });
    return notesList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getArchivedNotes();
    Timer(const Duration(milliseconds: 1100), () => getArchivedNotes());
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
            backgroundColor: bgColor,
          )
        : WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
            return true;
          },
          child: Scaffold(
              endDrawerEnableOpenDragGesture: true,
              key: _drawerKey,
              drawer: SideMenu(color_Notes: Colors.transparent, color_Archive: Colors.blue.shade800),
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
                              EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          width: MediaQuery.of(context).size.width,
                          height: 55,

                          /*MediaQuery.of(context).size.width retrieves the width of the screen.
                      The width property of the Container is set to the width of the screen, making it span the entire width horizontally.
                      The height property is set to 55, giving the Container a fixed height of 55 logical pixels.*/

                          child: Row(
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 5),
                                  IconButton(
                                      onPressed: () {
                                        _drawerKey.currentState!.openDrawer();
                                      },
                                      highlightColor:
                                          Colors.white.withOpacity(0.1),
                                      icon: Icon(
                                        Icons.menu,
                                        color: Colors.white.withOpacity(0.9),
                                      )),
                                  Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.63,

                                    /*the Container widget can have only one child directly.
                               However, you can use other widgets like Row, Column, Stack, or even nested Containers
                               to achieve layouts with multiple children.

                               If you need to have multiple children directly under a Container-like widget,
                               you can use widgets like Column or Row to arrange them vertically or horizontally, respectively,
                               within the Container.*/

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,

                                      // For a Row, the MAIN AXIS is horizontal, and for a Column, it's vertical.
                                      // Main axis alignment determines how children are positioned along the main axis.

                                      // For a Row, the CROSS AXIS is vertical, and for a Column, it's horizontal.
                                      // Cross axis alignment determines how children are positioned along the cross axis.

                                      children: [
                                        Text(
                                          "Archive",
                                          style: GoogleFonts.kumbhSans(
                                            textStyle: TextStyle(
                                                color:
                                                    Colors.white.withOpacity(0.9),
                                                fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SearchView()));
                                      },
                                    icon: Icon(Icons.search),
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isStaggered = !isStaggered;
                                      });
                                    },
                                    icon: isStaggered? Icon(Icons.view_agenda_outlined): Icon(Icons.grid_view_outlined),
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: isStaggered ? StaggeredView() : Listview(),

                  ),
                ]),
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
                        ArchiveView(note: notesList[index])));
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
      itemBuilder: (context, index) =>
          InkWell(
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
                      NotesDatabase.instance.intToColor(
                          notesList[index].color) ==
                          bgColor
                          ? Colors.grey
                          : Colors.transparent),
                  color: NotesDatabase.instance.intToColor(
                      notesList[index].color)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  notesList[index].pin ? Column(
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
                  ) : SizedBox(width: 0,),
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
