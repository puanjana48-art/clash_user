import 'package:clashproject/orderspage/checkout.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Cartpg extends StatefulWidget {
  const Cartpg({super.key});

  @override
  State<Cartpg> createState() => _CartpgState();
}

class _CartpgState extends State<Cartpg> {
  final String uid=FirebaseAuth.instance.currentUser!.uid;
  Future updateQuantity(String docId, int newQty) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection('cart')
        .doc(docId)
        .update({"quantity": newQty});
  }

  Future deleteItem(String docId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("cart")
        .doc(docId)
        .delete();
  }

  double getTotal(List cartDocs) {
    double total = 0;

    for (var item in cartDocs) {
      var data = item.data() as Map<String, dynamic>;
      double price = double.tryParse(data["price"].toString()) ?? 0;
      int qty = int.tryParse(data["quantity"].toString()) ?? 1;

      total += price * qty;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, size: 25,color: Colors.purple.shade100,),
        ),
        backgroundColor: Colors.blueGrey.shade400,
        title: Text('My Cart',style: TextStyle(color:Colors.purple.shade100,fontWeight: FontWeight.bold,)),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection('cart')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var cartItems = snapshot.data!.docs;

          return Column(
            children: [
              Expanded(
                child: cartItems.isEmpty
                    ?Center(
                  child: Text('cart is empty')
                )
                    :ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index];
                    var data = item.data() as Map<String, dynamic>;

                    double price = double.tryParse(data["price"].toString()) ?? 0;
                    double Price = double.tryParse(data["Price"].toString()) ?? 0;

                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          color: Colors.white,
                        ),
                        child: Column(

                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 75,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      image: DecorationImage(
                                        image: NetworkImage(data["image"]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data["name"],
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),

                                    if (data['size'] != null && data['size'].toString().isNotEmpty)
                                      Row(
                                        children: [
                                          Text('Size: ', style: TextStyle(color: Colors.black54)),
                                          Text(
                                            data['size'],
                                            style: TextStyle(color: Colors.black54),
                                          ),
                                        ],
                                      ),

                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.green, size: 15),
                                        SizedBox(width: 5),
                                        Text(
                                          (data['totalrating'] ?? 0).toString(),
                                          style: TextStyle(color: Colors.black, fontSize: 13),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Text(
                                          "₹$Price",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              decoration: TextDecoration
                                                  .lineThrough),
                                        ),
                                        SizedBox(width: 6),
                                        Text("₹$price",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Qty: "),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final q = await showDialog<int>(
                                      context: context,
                                      builder: (_) => SimpleDialog(
                                        title: Text("Select Quantity"),
                                        children: [1, 2, 3, 4].map((num) {
                                          return SimpleDialogOption(
                                            onPressed: () =>
                                                Navigator.pop(context, num),
                                            child: Text("$num"),
                                          );
                                        }).toList(),
                                      ),
                                    );

                                    if (q != null) updateQuantity(item.id, q);
                                  },
                                  child: Text(
                                    data["quantity"].toString(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => deleteItem(item.id),
                                  child: Row(
                                    children: [
                                      Text("Remove",style: TextStyle(color: Colors.black),),
                                      Icon(Icons.delete,color: Colors.red,),
                                    ],
                                  ),
                                  style:  TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black54,width: 0.8),borderRadius: BorderRadius.circular(7))
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if(cartItems.isNotEmpty)
              Container(
                height: 40,
                width: double.infinity,
                color: Colors.blueGrey.shade400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total : ₹${getTotal(cartItems).toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Checkoutpg(cartItems: cartItems),
                          ),
                        );
                      },
                      child: Text("Checkout"),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

