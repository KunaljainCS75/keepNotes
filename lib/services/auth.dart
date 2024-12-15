import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

//SIGN IN KA Function
Future<User?> signInWithGoogle() async
{
    User? user;

    //SIGNING IN WITH GOOGLE
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

    //CREATING CREDENTIAL FOR FIREBASE
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken
    );

    try {
        //SIGNING IN WITH CREDENTIAL & MAKING A USER IN FIREBASE  AND GETTING USER CLASS
        final userCredential = await _auth.signInWithCredential(credential);
        user = userCredential.user;


        //CHECKING IS ON
        assert(!user!.isAnonymous);
        assert(await user!.getIdToken() != null);

        final User? currentUser = await _auth.currentUser;
        assert(currentUser!.uid == user!.uid);
    }
    catch(e){
        print("$e from auth.dart");
    }
    print(user);
    return user;


}

void signOut() async
{
  await googleSignIn.signOut();
  await _auth.signOut();
}