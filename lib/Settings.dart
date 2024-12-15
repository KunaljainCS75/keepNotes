import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_notez/LoginInfo.dart';
import 'package:keep_notez/colors.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  bool value = false;
  getSyncSet() async{
    LocalDataSaver.getSyncSettings().then((valueFromDB){
     setState(() {
       value = valueFromDB!;
     });
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: bgColor,
        elevation: 0.0,
        title: Text("Settings", style: GoogleFonts.kumbhSans(
          textStyle: TextStyle(
            color: Colors.white, fontSize: 20
          )
        ),),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Text("Sync", style: GoogleFonts.kumbhSans(
            textStyle: TextStyle(
                color: Colors.white, fontSize: 20
            ))),
                Spacer(),
                Transform.scale(scale: 1, //sizeMultiplier of icon from current size
                  child: Switch.adaptive(value: value, onChanged: (switchvalue) {
                  setState(() {
                    this.value = switchvalue;
                    LocalDataSaver.saveSyncSettings(switchvalue);
                  });
                }))
              ],
            )
          ],
        ),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getSyncSet();
  }
}
