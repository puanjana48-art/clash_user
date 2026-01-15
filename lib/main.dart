import 'package:clashproject/checkout.dart';
import 'package:clashproject/editaddresspage.dart';
import 'package:clashproject/editpage.dart';
import 'package:clashproject/saved%20address.dart';
import 'package:clashproject/sugdetail1.dart';
import 'package:clashproject/loginpage.dart';
import 'package:clashproject/page1.dart';
import 'package:clashproject/splashpage.dart';
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