import 'package:clashproject/homepage/sugdetail1.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wish2 extends StatefulWidget {
  const Wish2({super.key});

  @override
  State<Wish2> createState() => _Wish2State();
}

class _Wish2State extends State<Wish2> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<bool> isInCart(String productId, String category) async {
    final cart = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("cart");

    final snapshot = await cart
        .where("productId", isEqualTo: productId)
        .where("category", isEqualTo: category)
        .get();

    return snapshot.docs.isNotEmpty;
  }


  Future<void> addToCart(Map<String, dynamic> product) async {
    final cart = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("cart");

    final existing =
    await cart.where("productId", isEqualTo: product["productId"]).get();

    if (existing.docs.isNotEmpty) return;

    await cart.add({
      "productId": product["productId"],
      "category": product["category"],
      "name": product["name"],
      "image": product["image"],
      "price": product["price"],
      "Price": product["Price"],
      "totalrating": product["totalrating"] ?? "0",
      "quantity": 1,
      "timestamp": DateTime.now(),
    });
  }

  Future<void> removeFromWishlist(String docId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("Wishlist")
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        toolbarHeight: 45,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon:  Icon(Icons.arrow_back,color: Colors.purple.shade100,),
        ),
        backgroundColor: Colors.blueGrey.shade600,
        title: Text("Wishlist",style: TextStyle(color: Colors.purple.shade100),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('Wishlist')
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs;

          if (items.isEmpty) {
            return const Center(
              child: Text("No Items in Wishlist", style: TextStyle(fontSize: 16)),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.64,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              final data = item.data() as Map<String, dynamic>;

              return Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Sug1(
                              category: data["category"],
                              productId: data["productId"],
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 150,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(data["image"]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: IconButton(
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                await removeFromWishlist(item.id);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text( data['name'].length > 35 ? '${data['name'].substring(0, 35)}...' : data['name'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black87), ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "₹${data["Price"]}",
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text("₹${data["price"]}"),
                      ],
                    ),
                    const SizedBox(height: 6),
                    FutureBuilder<bool>(
                      future: isInCart(data["productId"], data["category"]),
                      builder: (context, snap) {
                        final inCart = snap.data == true;

                        return TextButton(
                          onPressed: inCart
                              ? null
                              : () async {
                            await addToCart(data);
                            setState(() {});
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: inCart
                                ? Colors.grey.shade300
                                : Colors.blueGrey.shade400,
                            foregroundColor: Colors.black87,
                          ),
                          child: Text(
                            inCart ? "✓ Item in Cart" : "Add to Cart",
                            style: TextStyle(
                              color: inCart ? Colors.green : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
