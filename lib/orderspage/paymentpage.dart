import 'package:clashproject/orderspage/animate.dart';
import 'package:clashproject/orderspage/orderpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Payment extends StatefulWidget {
  final double totalAmount;
  final Map<String, dynamic>? buyNowProduct;
  final Map<String, dynamic> selectedAddress;


  const Payment({super.key, required this.totalAmount,this.buyNowProduct, required this.selectedAddress, });

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String Quantity = '1';
  String? Payment;
  String? PaymentMethods;

  late Razorpay razorpay;
  final String uid = FirebaseAuth.instance.currentUser!.uid;


  Future<void> placeCartOrder() async {
    final cartRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("cart");

    final userOrdersRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("orders");

     final adminOrdersRef =
     FirebaseFirestore.instance.collection("orders");



    final cartSnapshot = await cartRef.get();

    for (var doc in cartSnapshot.docs) {
      final address = widget.selectedAddress;
      final orderData = {
        ...doc.data(),
        "userId": uid,
        "customerName": address['Firstname'],
        "orderDate": Timestamp.now(),
        "orderStatus": "Placed",
        "expectedDeliveryDate": calculateExpectedDelivery("Placed"),
        "paymentMethod": PaymentMethods,
        "finalAmount": finalPayAmount,
        "orderType": "cart",
      };

      await userOrdersRef.add(orderData);
       await adminOrdersRef.add(orderData);

    }


    for (var doc in cartSnapshot.docs) {
      await cartRef.doc(doc.id).delete();
    }
  }

  Future<void> placeBuyNowOrder() async {
    if (widget.buyNowProduct == null) return;

    final userOrdersRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("orders");

    final adminOrdersRef =
    FirebaseFirestore.instance.collection("orders");
    final address = widget.selectedAddress;

    final orderData = {
      "name": widget.buyNowProduct!["name"],
      "image": widget.buyNowProduct!["image"],
      "price": widget.buyNowProduct!["price"],
      "quantity": widget.buyNowProduct!["quantity"] ?? 1,

      "userId": uid,
      "customerName": address['Firstname'],
      "orderDate": Timestamp.now(),
      "orderStatus": "Placed",
      "expectedDeliveryDate": calculateExpectedDelivery("Placed"),
      "paymentMethod": PaymentMethods,
      "finalAmount": finalPayAmount,
      "orderType": "buy_now",
    };



      await userOrdersRef.add(orderData);
      await adminOrdersRef.add(orderData);

  }


  int get deliveryCharge {
    return PaymentMethods == 'Cash on Delivery' ? 50 : 0;
  }

  double get finalPayAmount {
    return widget.totalAmount + deliveryCharge;
  }


  @override
  @override
  void initState() {
    super.initState();

    razorpay = Razorpay();

    razorpay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS,  handlePaymentSuccess);
    razorpay.on(
        Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(
        Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }
  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }
  void checkOut(int price) async {
    var options = {
      "key": "rzp_test_RxlctskTa9kaAf",
      "amount": price * 100,
      "name": "CLASH",
      "description": "CLASH shop your favourites",
      "prefill": {
        "contact": "9605865325",
        "email": "puanjana48@gmail.com",
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      log(e.toString());
    }
  }
  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    PaymentMethods = "razorpay";

    if (widget.buyNowProduct != null) {
      await placeBuyNowOrder();
    } else {
      await placeCartOrder();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OrderSuccessMessage()),
    );
  }





  void handlePaymentError(PaymentFailureResponse response) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("Something went wrong! Please try again"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Go back"),
            ),
          ],
        );
      },
    );
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => OrderSuccessMessage()),
    );}

  Timestamp calculateExpectedDelivery(String status) {
    int days;

    switch (status) {
      case 'Processing':
        days = 4;
        break;
      case 'Shipped':
        days = 2;
        break;
      case 'Delivered':
        days = 0;
        break;
      default: // Placed
        days = 5;
    }

    return Timestamp.fromDate(
      DateTime.now().add(Duration(days: days)),
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade400,
        title: Text('Payments', style: TextStyle(color: Colors.purple.shade100),),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Colors.purple.shade100)),
      ),

      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: PaymentMethods == null
              ? null
              : () async {
            if (PaymentMethods == 'Cash on Delivery') {
              if (widget.buyNowProduct != null) {
                await placeBuyNowOrder();
              } else {
                await placeCartOrder();
              }


              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const OrderSuccessMessage(),
                ),
              );
            } else if (PaymentMethods == 'razorpay') {
              checkOut(finalPayAmount.toInt());
            }
          },


          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueGrey.shade700,
            disabledBackgroundColor: Colors.grey.shade500,
            disabledForegroundColor: Colors.white,
          ),
          child: Text(
            "Payable Amount : ₹${finalPayAmount}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),


      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Card(
                child: Container(
                  height: 45,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey.shade300,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Amount :',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        "Pay ₹${widget.totalAmount}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),

                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Payment Method",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 10,
                      child: RadioListTile(
                        value: 'Cash on Delivery',
                        groupValue: Payment,
                        onChanged: (value){
                          setState(() {
                            Payment=value!;
                            PaymentMethods='Cash on Delivery';
                          });
                        },
                        title: Text('Cash on Delivery'),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 10,
                      child: RadioListTile(
                        value:'razorpay' ,
                        groupValue:Payment,
                        onChanged:(value){
                          setState(() {
                            Payment= value!;
                            PaymentMethods ='razorpay';
                          });
                        },
                        title: Text('Razorpay'),
                      ),
                    ),
                  ),

                  ExpansionTile(
                    title:Text('View Price Details',
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text("Total Price",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 17
                              ),),
                            Spacer(),
                            Text(
                              "Pay ₹${widget.totalAmount *int.parse(Quantity)}",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            // Text(
                            //   ": ₹ ${int.parse(args['totalPrice']) * int.parse(Quantity)} /-",
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.w600,
                            //       fontSize: 15
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              "Delivery Charge",
                              style:TextStyle(
                                  fontSize: 18,
                                  color: PaymentMethods == "razorpay"
                                      ? Colors.black
                                      : Colors.red),
                            ),
                            Spacer(),
                            Text(
                              PaymentMethods == "razorpay" ?
                              '₹ 0 /-': '₹ 50 /-',
                              style:TextStyle(
                                  fontSize: 18,
                                  color: PaymentMethods == "razorpay"
                                      ? Colors.black
                                      : Colors.red),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ]
            ),

          ],
        ),
      ),
    );
  }
}
