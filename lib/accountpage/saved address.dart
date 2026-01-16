import 'package:clashproject/accountpage/editaddresspage.dart';
import 'package:clashproject/accountpage/editpage.dart';
import 'package:clashproject/accountpage/savedadrees2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Address extends StatefulWidget {

  const Address({super.key});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  late final String uid;
  late final CollectionReference pro;

  TextEditingController firstname=TextEditingController();
  TextEditingController phonenumber=TextEditingController();
  TextEditingController pincode=TextEditingController();
  TextEditingController housenumber=TextEditingController();
  TextEditingController roadname=TextEditingController();
  TextEditingController city=TextEditingController();
  TextEditingController state =TextEditingController();

  @override
  void initState() {
    super.initState();

    uid = FirebaseAuth.instance.currentUser!.uid;

    pro = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('savedAddresses');
  }


  Future delete(id)async{
    await pro.doc(id).delete();
  }
  Future edit(docid)async{
    final data={
      'Housenumber':housenumber.text,
      'Roadname':roadname.text,
      'City':city.text,
      'State':state.text,
      'Pincode':pincode.text,
      'Phonenumber':phonenumber.text,
    };
    await pro.doc(docid).update(data);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.grey.shade300,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon:Icon(Icons.arrow_back,color: Colors.purple.shade100)),
        backgroundColor: Colors.blueGrey.shade400,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: pro.snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final snap=snapshot.data!.docs[index];
                    return Card(
                    color: Colors.grey.shade300,
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(snap['Firstname']),
                            PopupMenuButton(
                              icon: Icon(Icons.more_horiz, color: Colors.black54),
                              color: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              itemBuilder: (_) => [
                                PopupMenuItem(
                                    child: TextButton(onPressed: (){
                                   Navigator.of(context).pushNamed('editAddress',
                                     arguments: {
                                     'id':snap.id,
                                       'Housenumber':snap['Housenumber'].toString(),
                                       'Roadname':snap['Roadname'].toString(),
                                       'City':snap['City'].toString(),
                                       'State':snap['State'].toString(),
                                       'Pincode':snap['Pincode'].toString(),
                                       'Phonenumber':snap['Phonenumber'].toString()
                                     }
                                   );
                                    },
                                        child: Row(
                                          children: [
                                            Text('edit',style: TextStyle(color: Colors.black87
                                            ),),
                                            SizedBox(width: 7,),
                                            Icon(Icons.edit,color: Colors.black87,)
                                          ],
                                        ))
                                ),
                                PopupMenuItem(
                                    child: TextButton(onPressed: (){
                                      Navigator.pop(context);
                                      showDialog(context: context, builder: (context) => AlertDialog(
                                        content: Text('are you sure you want to delete'),
                                        actions: [
                                          TextButton(onPressed: (){
                                            Navigator.pop(context);
                                          },
                                              child: Text('No',style: TextStyle(color: Colors.blueGrey),)),
                                          TextButton(onPressed: (){
                                            delete(snap.id);
                                            Navigator.pop(context);
                                          }, child: Text('Yes',style: TextStyle(color: Colors.red),))
                                        ],
                                      ),);
                                    },
                                        child:Row(
                                          children: [
                                            Text("Delete",style: TextStyle(color: Colors.black87),),
                                            SizedBox(width: 5),
                                            Icon(Icons.delete,size: 16,color: Colors.black87,)
                                          ],
                                        ))),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snap['Housenumber']),
                            Text(snap['Roadname']),
                            Text(snap['City']),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${snap['State']} , '),
                                Text(snap['Pincode'],style: TextStyle(color: Colors.black),),
                              ],
                            ),
                            Text(snap['Phonenumber'],style: TextStyle(color: Colors.black),)

                          ],
                        ),
                      ),
                    );
                  },),
                ),
                Container(
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>Saved2(),));

                  },
                    child: Text('Add address +',style: TextStyle(color: Colors.indigo,fontSize: 16),),
                  ),
                ),

              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}
