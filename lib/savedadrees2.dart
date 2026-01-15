import 'package:clashproject/cartpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Saved2 extends StatefulWidget {
  const Saved2({super.key});

  @override
  State<Saved2> createState() => _Saved2State();
}

class _Saved2State extends State<Saved2> {
  late final String uid;
  late final CollectionReference pro;

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

  Future adddata()async{
    try{
      final data={
        'Firstname':firstname.text,
        'Phonenumber':phonenumber.text,
        'Pincode':pincode.text,
        'Housenumber':housenumber.text,
        'Roadname':roadname.text,
        'City':city.text,
        'State':state.text
      };
      await pro.add(data);
    }catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor:  Colors.grey.shade300,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Cartpg(),));
          },
              icon: Icon(Icons.shopping_cart,color: Colors.purple.shade100,)
          )],
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon:Icon(Icons.arrow_back,color: Colors.purple.shade100)),
        backgroundColor: Colors.blueGrey.shade400,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: firstname,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'First name(Required)*',
                labelStyle: TextStyle(fontSize: 15,color: Colors.black38),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38,width: 0.8)
                )
              ),

            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 10,
              controller: phonenumber,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),

                  labelText: 'Phone number(Required)*',
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
                  controller: textController,
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
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: state,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'State(Required)*',
                  labelStyle: TextStyle(fontSize: 15,color: Colors.black38),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38,width: 0.8)
                  )
              ),

            ),
          ),
          SizedBox(height: 20),
          TextButton(onPressed: (){
            Navigator.pop(context);
            adddata();
          },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:Colors.blueGrey.shade600
              ),
              child: Text('            Save Address           '))

        ],
      ),
    );
  }
}
