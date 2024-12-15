import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:keep_notez/LoginInfo.dart';
import 'package:path/path.dart';

import '../model/MyNoteModel.dart';

class FireDB{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //CREATE, READ, UPDATE, DELETE

  createNoteFirebase (Note note, String id)async{
    LocalDataSaver.getSyncSettings().then((isSyncOn)async{
      if(isSyncOn.toString() == "true") {
        try {
          final User? current_user = _auth.currentUser;
          await FirebaseFirestore.instance.collection("Notes").doc(
              current_user!.email).collection("userNotes").doc(id).set(
              {
                "Title": note.title,
                "Content": note.content,
                "Date": DateTime.now(),
              }, SetOptions(merge: true))
              .then((_) {
            print("Data Added successfully for NOTE-ID: ${note.id}");
          });
        }
        catch (e) {
          print(e);
        }
      }
    });
  }

  readNoteNotes()async {
    try {
      final User? current_user = _auth.currentUser;
      await FirebaseFirestore.instance.collection("Notes").doc(
          current_user!.email).collection("userNotes").get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          print(result.data());
        });
      });
    }
    catch(e){
      print(e);
    }
  }


  updateNoteFirebase (Note note)async {
    LocalDataSaver.getSyncSettings().then((isSyncOn) async {
      if (isSyncOn.toString() == "true") {
        try {
          final User? current_user = _auth.currentUser;
          await FirebaseFirestore.instance.collection("Notes").doc(
              current_user!.email)
              .collection("userNotes").doc(note.id.toString()).update(
              {
                "Title": note.title,
                "Content": note.content,
                "Date": DateTime.now()
              }).then((_) {
            print("Data updated successfully for NOTE-ID: ${note.id}");
          });
        }
      catch(e){
        print(e);
      }
    }
    });
  }

  deleteNoteFirebase (Note note)async {
    LocalDataSaver.getSyncSettings().then((isSyncOn) async {
      if (isSyncOn.toString() == "true") {
        try {
          final User? current_user = _auth.currentUser;
          await FirebaseFirestore.instance.collection("Notes").doc(
              current_user!.email)
              .collection("userNotes").doc(note.id.toString()).delete().then((
              _) {
            print("Data deleted successfully for NOTE-ID: ${note.id}");
          });
        }
        catch (e) {
          print("$e from FB.DATABASE.DART");
        }
      }
    });
  }
}