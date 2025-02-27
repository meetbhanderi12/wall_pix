import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper/main_page.dart';

import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    googleSignHandle();

  }
  void googleSignHandle()async {
    try {
      await InternetAddress.lookup("google.com");
      sp=await SharedPreferences.getInstance();
      if(sp.getBool("IsGooglelogdIn")??false){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage(),));

      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));

      }
    } catch (c) {
      final msg=SnackBar(content: Text("please Check Internet"),backgroundColor: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(msg);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height*100/100,
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(image: AssetImage("assets/rr.jpg"),fit: BoxFit.cover)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text("3D Wallpaper",style: TextStyle(color: Colors.white,fontSize: 18,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
              )
            ],),
          ),
          
        ],
      )
    );
  }
}
