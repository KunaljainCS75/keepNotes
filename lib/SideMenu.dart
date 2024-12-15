import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_notez/ArchiveSection.dart';
import 'package:keep_notez/Settings.dart';
import 'package:keep_notez/colors.dart';

import 'home.dart';

class SideMenu extends StatefulWidget {

  Color color_Notes;
  Color color_Archive;

  SideMenu({
    required this.color_Notes,
    required this.color_Archive,
});

  @override
  State<SideMenu> createState() => _SideMenuState();
}


class _SideMenuState extends State<SideMenu> {

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: bgColor, border: Border.all(color: Colors.transparent)),
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 16),
            decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 5),
                    Text("Google Keep", style: GoogleFonts.kumbhSans(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                      )
                    )),
                  ],
                ),
                Divider(
                  color: Colors.transparent,
                ),
                section_one(),
                section_two(),
                section_settings()
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget section_one()
  {
    return TextButton(onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    },

        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(widget.color_Notes),
        ),

        child: Row(
          children: [
            Icon(Icons.lightbulb_outlined, color: Colors.white),
            SizedBox(width: 10),
            Text("Notes", style: GoogleFonts.kumbhSans(
                textStyle: TextStyle(color: Colors.white, fontSize: 15)
            ),)
          ],
        ));
  }

  Widget section_two()
  {

    return TextButton(onPressed: () async{
      Navigator.push(context, MaterialPageRoute(builder: (context) => ArchiveSection()));
    },

        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(widget.color_Archive),
        ),

        child: Row(
          children: [
            Icon(Icons.archive_outlined, color: Colors.white),
            SizedBox(width: 10),
            Text("Archive", style: GoogleFonts.kumbhSans(
                textStyle: TextStyle(color: Colors.white, fontSize: 15)
            ),)
          ],
        ));
  }

  Widget section_settings()
  {
    return TextButton(onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
    },

        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
        ),

        child: Row(
          children: [
            Icon(Icons.settings_outlined, color: Colors.white),
            SizedBox(width: 10),
            Text("Settings", style: GoogleFonts.kumbhSans(
                textStyle: TextStyle(color: Colors.white, fontSize: 15)
            ),)
          ],
        ));
  }

}
