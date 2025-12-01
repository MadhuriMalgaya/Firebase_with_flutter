import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/ui/auth/login_screen.dart';
import 'package:flutter_with_firebase/ui/post/home.dart';
import 'package:flutter_with_firebase/ui/upload_image.dart';
import '../ui/firestore/firestore_list_screen.dart';

class SplashServices{
  void isLogin(BuildContext context){

    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if(user != null){
      Timer(Duration(seconds: 3), ()=>
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context)=> HomeScreen())
          )
      );
    }
    else{
      Timer(Duration(seconds: 3), ()=>
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context)=> LoginScreen())
          )
      );
    }
  }
}