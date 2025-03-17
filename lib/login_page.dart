import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wallpaper/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallpaper/repo/auth_services.dart';

late SharedPreferences sp;
final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
User? userDetails;
// bool isGuestAvaliable=true;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/farari.jpg"),fit:BoxFit.cover)
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
                  showDialog(context: context, builder: (context) => AlertDialog(
                    backgroundColor: Colors.white12,
                    content: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),);

                  AuthService auth = AuthService();
                  auth.signInWithGoogle().then((value) async {
                    sp = await SharedPreferences.getInstance();
                    sp.setBool("IsGooglelogdIn", true) ;
                    Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage(),));
                  },);
                  print("Login Successfully---------->");

                /*  try {
                    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
                    if (googleSignInAccount != null) {
                      Fluttertoast.showToast(msg: "Something Went Wrong");
                      return;
                    }
                      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
                      final OAuthCredential authCredential = GoogleAuthProvider.credential(
                        accessToken: googleSignInAuthentication.accessToken,
                        idToken: googleSignInAuthentication.idToken,
                      );
                      UserCredential userCredential = await auth.signInWithCredential(authCredential);
                      userDetails = userCredential.user;
                      sp=await SharedPreferences.getInstance();
                      sp.setBool("IsGooglelogdIn", true);
                      sp.setString("gmail", userDetails!.email.toString());
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage(),));





                  } catch (e) {
                    print("Error during Google Sign-In: $e");
                  }
*/
                },
                child: Container(
                  height: MediaQuery.of(context).size.height*7/100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(9))
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Icon(Icons.mail_outlined),
                      ),
                      SizedBox(width: 5,),
                      VerticalDivider(endIndent: 2.2,indent: 2.2,color: Colors.black,),
                      Text("Continue With Google",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage(),));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height*7/100,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(9))
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Icon(Icons.person),
                      ),
                      SizedBox(width: 5,),
                      VerticalDivider(endIndent: 2.2,indent: 2.2,color: Colors.black,),
                      Text("Continue as Guest",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),)
                    ],
                  ),

                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.06,)
            ],
          ),
        ),
        
        
      )
    );
  }
}
