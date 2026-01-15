import 'package:clashproject/savedadrees2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddressBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onSelect;

  AddressBottomSheet({required this.onSelect});

  @override
  State<AddressBottomSheet> createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet> {
  late final String uid;
  late final CollectionReference pro;
  @override
  void initState() {
    super.initState();

    uid = FirebaseAuth.instance.currentUser!.uid;

    pro = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('savedAddresses');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 450,
      child: Column(
        children: [
          Text(
            "Select Delivery Address",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: pro.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final snap = snapshot.data!.docs[index];

                    return Card(
                      child: ListTile(
                        title: Text(snap['Firstname']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snap['Housenumber']),
                            Text(snap['Roadname']),
                            Text(snap['City']),
                            Text("${snap['State']} - ${snap['Pincode']}"),
                            Text(snap['Phonenumber']),
                          ],
                        ),
                        trailing: Icon(Icons.radio_button_off),
                        onTap: () {
                          widget.onSelect({
                            'Firstname': snap['Firstname'],
                            'Housenumber': snap['Housenumber'],
                            'Roadname': snap['Roadname'],
                            'City': snap['City'],
                            'State': snap['State'],
                            'Pincode': snap['Pincode'],
                            'Phonenumber': snap['Phonenumber'],
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          TextButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Saved2()));
          },
              child: Text('Add new address +',style: TextStyle(color: Colors.blueGrey.shade800,fontSize: 16),))
          
        ],
      ),
    );
  }
}

