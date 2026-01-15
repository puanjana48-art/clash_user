import 'package:clashproject/Accountpage.dart';
import 'package:clashproject/loginpage.dart';
import 'package:clashproject/page1.dart';
import 'package:clashproject/productpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState(){
    super.initState();
    getloggeddata().whenComplete((){
      if(finaldata == true){
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Home()));
      }else{
        Future.delayed(Duration(seconds: 6),(){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
        });
      }
    });
  }
  bool ?finaldata ;
  Future getloggeddata()async{
    final SharedPreferences preferences=await SharedPreferences.getInstance();
    var getdata=preferences.getBool('islogged');
    setState(() {
      finaldata=getdata;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade800
        ),
        child: Center(
          child: Icon(Icons.handshake_sharp,size: 55,color: Colors.purple.shade100,),
        ),
      ),
    );
  }
}
