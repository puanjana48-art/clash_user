import 'package:clashproject/loginpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Sign extends StatefulWidget {
  const Sign({super.key});

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  TextEditingController mail=TextEditingController();
  TextEditingController pass=TextEditingController();
  TextEditingController confirm=TextEditingController();
  TextEditingController name=TextEditingController();
  Future<void> Signin() async {
    if (pass.text != confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Password and Confirm Password do not match'),
        ),
      );
      return;
    }

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail.text.trim(),
        password: pass.text.trim(),
      );

      User user = userCredential.user!;

   
      await user.updateDisplayName(name.text.trim());


      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'name': name.text.trim(),
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey.shade300,
          content: Text(
            'Account created successfully',
            style: TextStyle(color: Colors.black),
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.message ?? 'Signup failed'),
        ),
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
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               IconButton(onPressed: (){
                 Navigator.pop(context);
               }, icon:Icon(Icons.arrow_back)),
          SizedBox(height: 6),
           Padding(
              padding: const EdgeInsets.all(8.0),
                child: TextField(
                 controller: mail,
           decoration: InputDecoration(
           hintText: 'Email',
           hintStyle: TextStyle(
           color: Colors.blueGrey.shade400
          ),
                border: OutlineInputBorder(),
             enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey.shade800)),
             focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey.shade800,width: 2)),
           ),
           ),
                 ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: TextField(
                   controller: name,
                   decoration: InputDecoration(
                     hintText: 'Usename',
                     hintStyle: TextStyle(
                         color: Colors.blueGrey.shade400
                     ),
                     border: OutlineInputBorder(),
                     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey.shade800)),
                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey.shade800,width: 2)),
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
              labelText: 'password',
              labelStyle: TextStyle(
                  color: Colors.blueGrey.shade400
              ),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey.shade800)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey.shade800,width: 2)),
          ),
                ),
                ),
               SizedBox(height: 10),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: TextField(
                   controller: confirm,
                   obscureText: true,
                   maxLength: 10,
                   decoration: InputDecoration(
                     labelText: ' Confirmpassword',
                     labelStyle: TextStyle(
                         color: Colors.blueGrey.shade400
                     ),
                     border: OutlineInputBorder(),
                     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey.shade800)),
                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey.shade800,width: 2)),
                   ),
                 ),
               ),
              SizedBox(
              height: 15),
              Center(
                child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.only(left: 30,right: 30),
                   foregroundColor: Colors.white,
                   backgroundColor:Colors.blueGrey.shade800,
                  ),
                          onPressed: (){
                           Signin();
                          },
                          child: Text('signin',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
              ),
            ]

          )
              ),
        )
    );

  }
}
