import 'package:clashproject/shirtdetail1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Shirtpage extends StatefulWidget {
  const Shirtpage({super.key});

  @override
  State<Shirtpage> createState() => _ShirtpageState();
}

class _ShirtpageState extends State<Shirtpage> {
  final String uid=FirebaseAuth.instance.currentUser!.uid;

  List<bool> liked = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.purple.shade100)),
        backgroundColor: Colors.blueGrey.shade700,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .doc('shirt')
            .collection('items')
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var products = snapshot.data!.docs;
          if (liked.length != products.length) {
            liked = List<bool>.filled(products.length, false);
          }

          return GridView.builder(
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 20,
              childAspectRatio: 0.52,
            ),
            itemBuilder: (context, index) {
              var product = products[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Shirtdetail(category: 'shirt', productId: product.id),));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                      border: Border.all(color: Colors.black38, width: 1),
                    ),
                  
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Container(
                            height: 190,
                            width: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(product['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                  
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(uid)
                                        .collection('Wishlist')
                                        .where('productId', isEqualTo: product.id)
                                        .where('category', isEqualTo: 'shirt')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      final isLiked = snapshot.hasData && snapshot.data!.docs.isNotEmpty;

                                      return IconButton(
                                        icon: Icon(
                                          isLiked ? Icons.favorite : Icons.favorite_border,
                                          color: isLiked ? Colors.red : Colors.grey,
                                        ),
                                        onPressed: () async {
                                          final wishlist = FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(uid)
                                              .collection('Wishlist');

                                          if (isLiked) {
                                            // REMOVE
                                            await wishlist.doc(snapshot.data!.docs.first.id).delete();
                                          } else {
                                            // ADD
                                            await wishlist.add({
                                              "productId": product.id,
                                              "category": "shirt",
                                              "name": product["name"],
                                              "image": product["image"],
                                              "price": product["price"],
                                              "Price": product["Price"],
                                              "timestamp": DateTime.now(),
                                            });
                                          }
                                        },
                                      );
                                    },
                                  ),

                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(product['style'],
                              style: TextStyle(color: Colors.grey)),
                          Text(
                              product['name'].length>35
                              ?'${product['name'].substring(0,35)}...'
                              :product['name'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black, fontSize: 13)),
                          Row(
                            children: [
                              Text('₹${product['Price']}',style: TextStyle(decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.grey.shade500,
                                  decorationThickness: 2,
                                  color: Colors.grey),),
                              SizedBox(width: 5,),
                              Text("₹ ${product['price']}",
                                  style: TextStyle(color: Colors.black, fontSize: 13)),
                            ],
                          ),
                  
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.star,
                                  color: Colors.green, size: 15),
                              Text(product['totalrating'])
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
