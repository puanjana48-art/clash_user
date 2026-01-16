import 'package:clashproject/orderspage/checkout.dart';
import 'package:clashproject/accountpage/editaddresspage.dart';
import 'package:clashproject/accountpage/editpage.dart';
import 'package:clashproject/accountpage/saved%20address.dart';
import 'package:clashproject/homepage/sugdetail1.dart';
import 'package:clashproject/authentication/loginpage.dart';
import 'package:clashproject/mainpage/page1.dart';
import 'package:clashproject/authentication/splashpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'firebase_options.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      routes: {
        'editAddress': (context) => Editaddress(),

      },
      home: Splash(),
      debugShowCheckedModeBanner: false,
    ),


  );
}