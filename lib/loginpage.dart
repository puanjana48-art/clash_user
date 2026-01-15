import 'package:clashproject/Accountpage.dart';
import 'package:clashproject/Signup.dart';
import 'package:clashproject/forgot.dart';
import 'package:clashproject/page1.dart';
import 'package:clashproject/splashpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String?passwordError;
  TextEditingController mail=TextEditingController();
  TextEditingController pass=TextEditingController();
   Future login()async{
     try{

       final userCredential =await FirebaseAuth.instance.signInWithEmailAndPassword(email: mail.text, password: pass.text);

       final user =userCredential.user;
       await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
         'uid': user.uid,
         'name': user.displayName ?? mail.text.split('@')[0],
         'email': user.email,
         'lastLogin': FieldValue.serverTimestamp(),
       }, SetOptions(merge: true));
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
             backgroundColor: Colors.grey.shade300,
             content: Text('login succesfull',style: TextStyle(color: Colors.black),))
       );
      final SharedPreferences preferences=await SharedPreferences.getInstance();
      preferences.setBool('islogged', true);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Splash(),));
     }catch(e){
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
             backgroundColor: Colors.red,
             content: Text('login failed$e'))
       );
     }
   }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.grey.shade300,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('lib/images/strt.jpg'),fit: BoxFit.cover)
        ),
        child: Center(
          child: Container(
            height: 500,
            width: 300,
            child: Center(
              child:  Column(
        children: [
          SizedBox(height: 6),
          Text('Login',style: TextStyle(color: Colors.blueGrey.shade800,fontSize: 30)),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: mail,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black,width: 1)
                ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey.shade800,width: 1)
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    color: Colors.blueGrey.shade400,
                  ),
                  border: OutlineInputBorder()
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: pass,
              obscureText: true,
              maxLength: 10,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black,width: 1)
                ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey.shade800,width: 1)
                  ),
                  labelText: 'password',
                  errorText: passwordError,
                  labelStyle: TextStyle(
                      color: Colors.blueGrey.shade400
                  ),
                  border: OutlineInputBorder(),
                counterText: '',
              ),
              onChanged: (password){
                setState(() {
                  final password=pass.text;
                  if(password.length<10){
                    passwordError='password must be  atleast 10 characters';
                  }else{
                    passwordError=null;
                  }
                });
              },
            ),
          ),
          SizedBox(
              height: 15),
          TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.only(left: 30,right: 30),
                foregroundColor: Colors.white,
                backgroundColor:Colors.blueGrey.shade800,
              ),
              onPressed: ()async{
                  login();


              }, child: Text('LOGIN',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
          SizedBox(height: 15),
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Forgg()));
          }, child:Text('forgot password',style: TextStyle(color: Colors.blueGrey.shade800),)),
          SizedBox(height: 4),
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Sign(),));
          }, child: Text('Not a member?Sign up',style: TextStyle(color: Colors.blueGrey.shade800),))



        ],
      ),
            ),
          ),
        ),
      ),
    );
  }
}
