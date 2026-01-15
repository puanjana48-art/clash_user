import 'package:clashproject/page1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Orderpage extends StatefulWidget {
  const Orderpage({super.key});

  @override
  State<Orderpage> createState() => _OrderpageState();
}

class _OrderpageState extends State<Orderpage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Color getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      case 'Placed':
        return Colors.orange;
      case 'Shipped':
        return Colors.blue;
      case 'Processing':
      default:
        return Colors.brown;
    }
  }

  Future<void> rateProduct({
    required String orderDocId,
    required int rating,
  }) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("orders")
        .doc(orderDocId)
        .update({"rating": rating});
  }

  Future<void> cancelOrder({required String orderDocId}) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("orders")
        .doc(orderDocId)
        .update({"orderStatus": "Cancelled"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home()));
          },
          icon: Icon(Icons.arrow_back,color: Colors.purple.shade100),
        ),
        title:  Text("My Orders",style: TextStyle(color: Colors.purple.shade100),),
        backgroundColor: Colors.blueGrey.shade600,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("orders")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return const Center(child: Text("No orders yet"));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var data = orders[index].data() as Map<String, dynamic>;
              var orderId = orders[index].id;

              bool hasRatingField = data.containsKey("rating");
              int currentRating = hasRatingField ? (data["rating"] ?? 0) : 0;
              bool alreadyRated = hasRatingField && currentRating > 0;
              String orderStatus = data['orderStatus'];
              Timestamp? ts = data['expectedDeliveryDate'];

              String deliveryText;
              if (orderStatus == 'Delivered') {
                deliveryText = ts != null
                    ? "Delivered on ${ts.toDate().day}-${ts.toDate().month}-${ts.toDate().year}"
                    : "Delivered";
              } else if (orderStatus == 'Cancelled') {
                deliveryText = "Order cancelled";
              } else {
                deliveryText = ts != null
                    ? "Expected delivery: ${ts.toDate().day}-${ts.toDate().month}-${ts.toDate().year}"
                    : "Delivery date unavailable";
              }

              bool canCancel =
                  orderStatus != 'Cancelled' && orderStatus != 'Delivered';
              bool showRating = orderStatus == 'Delivered';


              return Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 100,
                      width: 70,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(data["image"].toString()),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  data["name"].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text("Qty: ${data["quantity"].toString()}"),
                          Text("₹${data["price"].toString()}"),
                          if (showRating) ...[
                            Row(
                              children: List.generate(5, (i) {
                                int starValue = i + 1;
                                return IconButton(
                                  icon: Icon(
                                    starValue <= currentRating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: alreadyRated
                                        ? Colors.amber
                                        : Colors.blueGrey.shade600,
                                    size: 21,
                                  ),
                                  padding: EdgeInsets.zero,
                                  onPressed: alreadyRated
                                      ? null
                                      : () {
                                    rateProduct(
                                        orderDocId: orderId,
                                        rating: starValue);
                                  },
                                );
                              }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0.3, left: 8),
                              child: Text(
                                alreadyRated
                                    ? 'Thanks for your rating!'
                                    : 'Rate this product',
                                style: TextStyle(
                                  color:
                                  alreadyRated ? Colors.green : Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                          Row(
                            children: [
                              Text('Status: '),
                              Text(
                                orderStatus,
                                style: TextStyle(
                                  color: getStatusColor(orderStatus),
                                ),
                              ),
                               SizedBox(width: 50),
                              if (canCancel)
                                ElevatedButton(
                                  onPressed: () async {
                                    showDialog(context: context,
                                        builder: (context) => AlertDialog(
                                          content: Text('"Are you sure you want to cancel your order"'),
                                          actions: [
                                            TextButton(onPressed: (){
                                              Navigator.pop(context);
                                            },
                                                child: Text('No',style: TextStyle(color: Colors.blueGrey),)),
                                            TextButton(onPressed: ()async{
                                              Navigator.pop(context);
                                              await cancelOrder(orderDocId: orderId);
                                            },
                                                child: Text('cancel',style: TextStyle(color: Colors.red),))
                                          ],
                                        ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueGrey.shade500,
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(5, 35),
                                  ),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                          Text(
                            deliveryText,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
