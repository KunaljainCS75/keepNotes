import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_notez/LoginInfo.dart';
import 'package:keep_notez/colors.dart';
import 'package:keep_notez/home.dart';
import 'package:keep_notez/services/auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            SizedBox(height: 20,),
            SignInButton(Buttons.GoogleDark,
                onPressed:() async{
              await signInWithGoogle();
              final User? currentUser = await _auth.currentUser;
              LocalDataSaver.saveLoginData(true);
              try {
                LocalDataSaver.saveImg(currentUser!.photoURL.toString());
                LocalDataSaver.saveMail(currentUser.email.toString());
                LocalDataSaver.saveName(currentUser.displayName.toString());
              }
              catch(e){
                print(e);
              }
              LocalDataSaver.saveSyncSettings(false);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
            })
          ],
        ),
      ),
    );

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LocalDataSaver.saveSyncSettings(false);
  }
}
