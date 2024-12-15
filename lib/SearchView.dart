

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_notez/colors.dart';
import 'package:keep_notez/services/NotesDatabase.dart';
import 'NotesView.dart';
import 'model/MyNoteModel.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  List <int> SearchResultIDs = [];
  List <Note> SearchResultNotes = [];

  bool isLoading = false;
  bool isEmpty = true;

  void SearchResults(String query) async{
    SearchResultNotes.clear();
    setState(() {
      isLoading = true;
    });
    final ResultIds = await NotesDatabase.instance.getNoteStringforSearch(query); //= [1,2,3,4,5]
    List<Note?> SearchResultNotesLocal = []; //[nOTE1, nOTE2]
    ResultIds.forEach((element) async{
      final SearchNote = await NotesDatabase.instance.readOneNote(element);
      SearchResultNotesLocal.add(SearchNote);
      setState(() {

        SearchResultNotes.add(SearchNote!);

      });
    });

    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: bgColor,
        elevation: 0.0,
        title: TextField(
            textInputAction: TextInputAction.search,
            onSubmitted: (value)async{
              SearchResults(value.toLowerCase());
            },
            cursorColor: Colors.white,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search your notes",
                hintStyle: GoogleFonts.kumbhSans(
                    textStyle: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16
                    )
                )
            ),
            style: GoogleFonts.kumbhSans(
                textStyle: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16
                )
            )
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(

                        ),
                        child:  isEmpty? StaggeredGridView.countBuilder(
                            shrinkWrap: true,
                            itemCount: SearchResultNotes.length,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            crossAxisCount: 4,
                            staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                            itemBuilder: (context, index) =>
                                InkWell(
                                  onTap: ()
                                  {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => NotesView(note: SearchResultNotes[index])));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: NotesDatabase.instance
                                                .intToColor(SearchResultNotes[index].color) ==
                                                bgColor
                                                ? Colors.grey
                                                : Colors.transparent),
                                        color: NotesDatabase.instance
                                            .intToColor(SearchResultNotes[index].color)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SearchResultNotes[index].pin? Column(
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
                                          SearchResultNotes[index].title,
                                          style: GoogleFonts.kumbhSans(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          SearchResultNotes[index].content.length > 250
                                              ? "${SearchResultNotes[index].content.substring(0, 250)}..."
                                              : SearchResultNotes[index].content,
                                          style: GoogleFonts.kumbhSans(
                                              textStyle: TextStyle(color: Colors.white)),
                                        )
                                      ],
                                    ),
                                  ),

                                )
                        ): Container(),
                    ),
                  ],
                )
            ),
          ],
        ),
      )
    );
  }

  // Widget notfound(){
  //   return SingleChildScrollView(
  //   child: Container(
  //   child: Center(
  //   child: IntrinsicHeight(
  //   child: Column(
  //   children: [
  //   SizedBox(height: MediaQuery.of(context).size.height*.3,),
  //   Image.asset("images/img_1.png", height: 150,),
  //   SizedBox(height: 10),
  //   Text("No Matching Notes", style: GoogleFonts.kumbhSans(
  //   textStyle: TextStyle(
  //   color: Colors.white, fontSize: 20
  //   )
  //   ),)
  //
  //   ],
  //   ),
  //   ),
  //   )
  //   ),
  //   ),
  // }


}