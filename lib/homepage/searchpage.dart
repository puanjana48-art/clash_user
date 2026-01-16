import 'package:clashproject/homepage/sugdetail1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
List<dynamic> availableCategories = [];
List<dynamic> filteredCategories = [];


class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController search = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    filterCategory(value);
                  });
                },
                controller: search,
                cursorColor:Colors.blueGrey.shade800,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                  ),
                  hintText: 'Search Here',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.blueGrey.shade800
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color:Color(0xff7b0001),
                      )
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/1.2,
              child: StreamBuilder(
                  stream:FirebaseFirestore.instance.collectionGroup('items').snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasError){
                      return Text('Erorr ::${snapshot.hasError}');
                    }else if (snapshot.hasData) {
                      availableCategories = snapshot.data!.docs;
                      if (search.text.isEmpty) {
                        filteredCategories = availableCategories;
                      }
                      return GridView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredCategories.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final snap = filteredCategories[index];
                          final category =
                              snap.reference.parent.parent!.id;
                          final productId = snap.id;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Sug1(
                                    category: category,
                                    productId: productId,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Card(
                                color: Colors.white,
                                shadowColor: Colors.blueGrey.shade800,
                                elevation: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.white70,
                                  ),
                                  height: 100,
                                  width: 100,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 12),
                                      SizedBox(
                                        height: 200,
                                        child: ClipRRect(
                                          child: Image(
                                            image: NetworkImage( snap["image"]),
                                            height: 250,
                                            width: 180,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          snap['name'],
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 20,
                                            color: Colors.blueGrey.shade800,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 20,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          mainAxisExtent: 250.0,

                        ),

                      );
                    }
                    return CircularProgressIndicator();
                  }
              ),
            )
          ],
        ),
      )
    );
  }
  void filterCategory(String query) {
    setState(() {
      final searchText = query.toLowerCase();

      filteredCategories = availableCategories.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final name =
        data['name'].toString().toLowerCase();

        return name.contains(searchText);
      }).toList();
    });
  }
}