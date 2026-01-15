import 'package:clashproject/Notificationpage.dart';
import 'package:clashproject/editpage.dart';
import 'package:clashproject/helppage.dart';
import 'package:clashproject/loginpage.dart';
import 'package:clashproject/page1.dart';
import 'package:clashproject/privacy/privacy.dart';
import 'package:clashproject/saved%20address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final String uid=FirebaseAuth.instance.currentUser!.uid;

  Future logout()async{
    try{
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.green,
              content: Text('Logout successfull'))
      );
      final SharedPreferences preferences =await SharedPreferences.getInstance();
      preferences.setBool('islogged', false);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text('Logout failed'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 23,
        automaticallyImplyLeading: false,
        title: Text('Account setting',style: TextStyle(color:Colors.purple.shade100,fontWeight: FontWeight.bold,),),
        toolbarHeight: 45,
        backgroundColor: Colors.blueGrey.shade600,
      ),
      backgroundColor:  Colors.grey.shade300,
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            Card(
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blueGrey.shade800,
                        spreadRadius: 3,
                        blurRadius: 6,
                        offset: Offset(0, 3)
                    )
                  ],
                ),
                child: Center(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .collection('profile')
                        .doc(uid)
                        .snapshots(),
                    builder: (context, snapshot) {


                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Text("No profile data found");
                      }

                      final data = snapshot.data!.data() as Map<String, dynamic>;

                      String gender = data['gender'] ?? 'boy';
                      String name = data['name'] ?? '';
                      String phone = data['phone'] ?? '';
                      String email = data['email'] ?? '';

                      return Column(
                        children: [
                          const SizedBox(height: 30),

                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.blueGrey.shade200,
                            backgroundImage: AssetImage(
                              gender == 'girl'
                                  ? 'lib/images/Sk.jpg'
                                  : 'lib/images/boy.jpg',
                            ),
                          ),

                          const SizedBox(height: 10),

                          ListTile(
                            title: Center(
                              child: Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            subtitle: Column(
                              children: [
                                Text(phone),
                                Text(email),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                ),
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blueGrey.shade800,
                          spreadRadius: 3,
                          blurRadius: 6,
                          offset: Offset(0, 3)
                      )
                    ],
                  ),
                  child:TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Edit(),));

                  }, child: Row(
                    children: [
                      Icon(Icons.person_add_alt_1_rounded,color: Colors.indigo,size: 25,),
                      SizedBox(width: 8),
                      Text('Edit profile',style: TextStyle(color: Colors.black,fontSize: 16),),
                    ],
                  ),),
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blueGrey.shade800,
                        spreadRadius: 3,
                        blurRadius: 6,
                        offset: Offset(0, 3)
                    )
                  ],
                ),
                child:TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Address(),));
                }, child: Row(
                  children: [
                    Icon(Icons.location_on,color: Colors.indigo,size: 25,),
                    SizedBox(width: 8),
                    Text('Saved address',style: TextStyle(color: Colors.black,fontSize: 16),),
                  ],
                ),)
              ),
            ),
           
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blueGrey.shade800,
                        spreadRadius: 3,
                        blurRadius: 6,
                        offset: Offset(0, 3)
                    )
                  ],
                ),
               child:TextButton(onPressed: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context) => Helpcentre(),));
               }, child: Row(
                    children: [
                      Icon(Icons.help,color: Colors.indigo,size: 25,),
                      SizedBox(width: 8),
                      Text('Help centre',style: TextStyle(color: Colors.black,fontSize: 16),),
                    ],
                  ),)
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blueGrey.shade800,
                          spreadRadius: 3,
                          blurRadius: 6,
                          offset: Offset(0, 3)
                      )
                    ],
                  ),
                  child:TextButton(onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => Privacy(mdFilename: 'privacypolicy.md')));
                  }, child: Row(
                    children: [
                      Icon(Icons.security,color: Colors.indigo,size: 25,),
                      SizedBox(width: 8),
                      Text('Privacy & policy',style: TextStyle(color: Colors.black,fontSize: 16),),
                    ],
                  ),)
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blueGrey.shade800,
                          spreadRadius: 3,
                          blurRadius: 6,
                          offset: Offset(0, 3)
                      )
                    ],
                  ),
                  child:TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Terms1(mdFilename: 'lib/terms/terms_conditions.md')));
                  }, child: Row(
                    children: [
                      Icon(Icons.privacy_tip,color: Colors.indigo,size: 25,),
                      SizedBox(width: 8),
                      Text('terms & conditions',style: TextStyle(color: Colors.black,fontSize: 16),),
                    ],
                  ),)
              ),
            ),

            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blueGrey.shade800,
                          spreadRadius: 3,
                          blurRadius: 6,
                          offset: Offset(0, 3)
                      )
                    ],
                  ),
                  child:TextButton(onPressed: (){
                   setState(() {
                     logout();
                   });
                  }, child: Row(
                    children: [
                      Icon(Icons.output,color: Colors.red,size: 25,),
                      SizedBox(width: 8),
                      Text('Logout',style: TextStyle(color: Colors.black,fontSize: 16),),
                    ],
                  ),)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
