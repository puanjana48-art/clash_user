import 'package:clashproject/orderspage/checkout.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clashproject/cartpage/cartpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clashproject/models/buynow.dart';

class Frockdetail extends StatefulWidget {
  final String category;
  final String productId;

  const Frockdetail({
    super.key,
    required this.category,
    required this.productId,
  });

  @override
  State<Frockdetail> createState() => _FrockdetailState();
}

class _FrockdetailState extends State<Frockdetail> {
  int selectedSizeIndex = -1;
  int selectedImageIndex = 0;

  bool isLiked = false;
  bool isInCart = false;

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  String _name(int index) {
    switch (index) {
      case 0:
        return 'S';
      case 1:
        return 'XL';
      case 2:
        return 'M';
      default:
        return '';
    }
  }

  String? getSelectedSize() {
    if (selectedSizeIndex == -1) return null;
    return _name(selectedSizeIndex);
  }

  @override
  void initState() {
    super.initState();
    checkCartStatus();
    checkWishlistStatus();
  }

  Future<void> checkCartStatus() async {
    final cart = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("cart");

    final existing = await cart
        .where("productId", isEqualTo: widget.productId)
        .where("category", isEqualTo: widget.category)
        .get();

    if (existing.docs.isNotEmpty) {
      setState(() => isInCart = true);
    }
  }

  Future<void> checkWishlistStatus() async {
    final wishlist = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("Wishlist");

    final existing = await wishlist
        .where("productId", isEqualTo: widget.productId)
        .where("category", isEqualTo: widget.category)
        .get();

    if (existing.docs.isNotEmpty) {
      setState(() => isLiked = true);
    }
  }


  Future<void> addToWishlist(Map<String, dynamic> product) async {
    final wishlist = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("Wishlist");

    final existing = await wishlist
        .where("productId", isEqualTo: widget.productId)
        .where("category", isEqualTo: widget.category)
        .get();

    if (existing.docs.isNotEmpty) {
      await wishlist.doc(existing.docs.first.id).delete();
      setState(() => isLiked = false);
      return;
    }

    await wishlist.add({
      "productId": widget.productId,
      "category": widget.category,
      "name": product["name"],
      "image": product["image"],
      "price": product["price"],
      "Price": product["Price"],
      "totalrating": product["totalrating"] ?? "0",
      "timestamp": DateTime.now(),
    });

    setState(() => isLiked = true);
  }

  Future<void> addToCart(Map<String, dynamic> product) async {
    if (selectedSizeIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a size'),
          backgroundColor: Colors.blueGrey.shade700,
        ),
      );
      return;
    }

    final cart = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("cart");

    final existing = await cart
        .where("productId", isEqualTo: widget.productId)
        .where("category", isEqualTo: widget.category)
        .get();

    if (existing.docs.isNotEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => Cartpg()));
      return;
    }

    await cart.add({
      "productId": widget.productId,
      "category": widget.category,
      "name": product["name"],
      "image": product["image"],
      "price": product["price"],
      "Price": product["Price"],
      "size": getSelectedSize(),
      "totalrating": product["totalrating"],
      "quantity": 1,
      "timestamp": DateTime.now(),
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('added to cart'),backgroundColor: Colors.blueGrey.shade800,));

    setState(() => isInCart = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        toolbarHeight: 45,
        backgroundColor: Colors.blueGrey.shade800,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back,color: Colors.purple.shade100,),
        ),
      ),


      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("products")
            .doc(widget.category)
            .collection("items")
            .doc(widget.productId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final product = snapshot.data!.data() as Map<String, dynamic>;
          final List<String> images =
          List<String>.from(product['images'] ?? []);

          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                SizedBox(
                  height: 480,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: PageView.builder(
                          itemCount: images.length,
                          onPageChanged: (i) =>
                              setState(() => selectedImageIndex = i),
                          itemBuilder: (_, i) => Image.network(
                            images[i],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: Icon(
                            isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                            size: 30,
                          ),
                          onPressed: () => addToWishlist(product),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text("Select Size",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),

                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(6),
                        child: InkWell(
                          onTap: () =>
                              setState(() => selectedSizeIndex = index),
                          child: Container(
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selectedSizeIndex == index
                                  ? Colors.blueGrey.shade700
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: selectedSizeIndex == index
                                      ? Colors.black
                                      : Colors.grey),
                            ),
                            child: Text(
                              _name(index),
                              style: TextStyle(
                                color: selectedSizeIndex == index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star,
                              color: Colors.green, size: 15),
                          Text(product['totalrating'])
                        ],
                      ),
                      SizedBox(height: 6,),
                      Text(product['name'],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10,),
                      Text(product['color'],
                          style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 14,),
                      Text(product['description']),
                      SizedBox(height: 18),
                      Row(
                        children: [
                          Text("₹${product['Price']}",
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,fontSize: 24,color: Colors.grey,decorationColor: Colors.grey)),
                          SizedBox(width: 8),
                          Text("₹${product['price']}",
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),


      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade800,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final snap = await FirebaseFirestore.instance
                      .collection("products")
                      .doc(widget.category)
                      .collection("items")
                      .doc(widget.productId)
                      .get();
                  addToCart(snap.data()!);
                },
                child: Text(isInCart ? "Go to Cart" : "Add to Cart"),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade800,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  if (selectedSizeIndex == -1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please select a size'),
                        backgroundColor: Colors.blueGrey.shade700,
                      ),
                    );
                    return;
                  }

                  final snap = await FirebaseFirestore.instance
                      .collection("products")
                      .doc(widget.category)
                      .collection("items")
                      .doc(widget.productId)
                      .get();

                  final product = snap.data()!;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Checkoutpg(
                        cartItems: [
                          Checkcart({
                            "productId": widget.productId,
                            "category": widget.category,
                            "name": product["name"],
                            "image": product["image"],
                            "price": product["price"],
                            "Price": product["Price"],
                            'totalrating':product['totalrating'],
                            "size": getSelectedSize(),
                            "quantity": 1,
                          })
                        ],
                      ),
                    ),
                  );
                },
                child: Text("Buy Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
