import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Editaddress extends StatefulWidget {
  const Editaddress({super.key});

  @override
  State<Editaddress> createState() => _EditaddressState();
}

class _EditaddressState extends State<Editaddress> {
  final List<String> cities = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Chennai',
    'Hyderabad',
    'Kochi',
    'Trivandrum',
    'Kozhikode',
    'Coimbatore',
    'Madurai',
    'Pune',
    'Kolkata',
    'Ernakulam',
    'palakkad',
    'kollam',
    'Thrissur',
    'Pathanamthitta',
    'Kasagode',
    'kannur',
    'Wayannad',
    'Aalapuzha',
    'idukki',
    'Malapuram',
    'Kannur',

  ];

  final CollectionReference pro=FirebaseFirestore.instance
      .collection('products')
      .doc('savedAddress')
      .collection('items');

  TextEditingController firstname=TextEditingController();
  TextEditingController phonenumber=TextEditingController();
  TextEditingController pincode=TextEditingController();
  TextEditingController housenumber=TextEditingController();
  TextEditingController roadname=TextEditingController();
  TextEditingController city=TextEditingController();
  TextEditingController state =TextEditingController();

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
    final args =ModalRoute.of(context)!.settings.arguments as Map;
    housenumber.text=args['Housenumber'];
    roadname.text=args['Roadname'];
    city.text=args['City'];
    state.text=args['State'];
    pincode.text=args['Pincode'];
    phonenumber.text=args['Phonenumber'];
    var docid=args['id'];

    return Scaffold(
      backgroundColor:  Colors.grey.shade300,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon:Icon(Icons.arrow_back)),
        backgroundColor: Colors.blueGrey.shade400,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: housenumber,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'House No.Building Name(Required)*',
                  labelStyle: TextStyle(fontSize: 15,color: Colors.black38),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38,width: 0.8)
                  )
              ),

            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: roadname,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Road name,Area,Colony(Required)*',
                  labelStyle: TextStyle(fontSize: 15,color: Colors.black38),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38,width: 0.8)
                  )
              ),

            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return cities.where((String option) {
                  return option
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                city.text = selection;
              },
              fieldViewBuilder:
                  (context, textController, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: city,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'City (Required)*',
                    labelStyle: TextStyle(fontSize: 15,color: Colors.black38),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 0.8),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding:  EdgeInsets.all(8.0),
            child: TextField(
              controller: pincode,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Pin Code(Required)*',
                  labelStyle: TextStyle(fontSize: 15,color: Colors.black38),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38,width: 0.8)
                  )
              ),

            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 10,
              controller: phonenumber,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'phone number',
                  labelStyle: TextStyle(fontSize: 15,color: Colors.black38),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38,width: 0.8)
                  )
              ),

            ),
          ),
          SizedBox(height: 20),
          TextButton(onPressed: (){
            edit(docid);
            Navigator.pop(context);

          },
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:Colors.blueGrey.shade600
              ),
              child: Text('            Update Address          '))

        ],
      ),
    );
  }
}
