import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgg extends StatefulWidget {
  const Forgg({super.key});

  @override
  State<Forgg> createState() => _ForggState();
}

class _ForggState extends State<Forgg> {
  TextEditingController remail=TextEditingController();
  Future forget()async{
    try{
      final email =remail.text;
      if(email.contains('@')){
      await  FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.green,
                content: Text('Reset link send to your mail $email'))
        );
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text('invalid mail$e'))
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon:Icon(Icons.arrow_back)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: remail,
                decoration: InputDecoration(
                    hintText: ' Enter a new password',
                    hintStyle: TextStyle(
                        color: Colors.blueGrey.shade400
                    ),
                    border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey.shade800,width: 1)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey.shade800,width: 2)),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.only(left: 30,right: 30),
                    foregroundColor: Colors.white,
                    backgroundColor:Colors.blueGrey.shade800,
                  ),
                  onPressed: (){
                    setState(() {
                      forget();
                    });
                  },
                  child: Text('Save password')),
            )
          ],
        ),
      ),
    );
  }
}
