import 'package:clashproject/orderspage/bottomsheetpage.dart';
import 'package:clashproject/orderspage/paymentpage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Checkoutpg extends StatefulWidget {
  final List cartItems;
  final Map<String, dynamic>? buyNowProduct;

  const Checkoutpg({super.key, required this.cartItems, this.buyNowProduct,});

  @override
  State<Checkoutpg> createState() => _CheckoutpgState();
}

class _CheckoutpgState extends State<Checkoutpg> {
  Map<String, dynamic>? selectedAddress;

  @override
  void initState() {
    super.initState();
    loadSavedAddress();
  }

  double getTotal() {
    double total = 0;
    for (var item in widget.cartItems) {
      var data = item.data() as Map<String, dynamic>;
      double price = double.tryParse(data["price"].toString()) ?? 0;
      int qty = int.tryParse(data["quantity"].toString()) ?? 1;
      total += price * qty;
    }
    return total;
  }


  Future<void> loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();

    final firstname = prefs.getString('addr_firstname');
    if (firstname == null) return;

    setState(() {
      selectedAddress = {
        'Firstname': firstname,
        'Housenumber': prefs.getString('addr_house'),
        'Roadname': prefs.getString('addr_road'),
        'City': prefs.getString('addr_city'),
        'State': prefs.getString('addr_state'),
        'Pincode': prefs.getString('addr_pincode'),
        'Phonenumber': prefs.getString('addr_phone'),
      };
    });
  }

  void showAddressSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return AddressBottomSheet(
          onSelect: (address) async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('addr_firstname', address['Firstname']);
            await prefs.setString('addr_house', address['Housenumber']);
            await prefs.setString('addr_road', address['Roadname']);
            await prefs.setString('addr_city', address['City']);
            await prefs.setString('addr_state', address['State']);
            await prefs.setString('addr_pincode', address['Pincode']);
            await prefs.setString('addr_phone', address['Phonenumber']);
            setState(() {
              selectedAddress = address;
            });

            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = getTotal();

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        leading: BackButton(color: Colors.purple.shade100),
        title: Text('Order Summary',style: TextStyle(color: Colors.purple.shade100),),
        backgroundColor: Colors.blueGrey.shade400,
      ),
      bottomNavigationBar: Container(
        height: 45,
        color: Colors.blueGrey.shade400,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Total : ₹$totalAmount",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                if (selectedAddress == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please select delivery address"),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>  Payment(
                    totalAmount: totalAmount,
                    buyNowProduct: widget.buyNowProduct,
                    selectedAddress: selectedAddress!,
                  ),

                ),
                  );

                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: Text(
                "Continue",
                style: TextStyle(color: Colors.indigo),
              ),
            )

          ],
        ),
      ),


      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                color: Colors.white,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Deliver to:"),
                      OutlinedButton(
                        onPressed: showAddressSheet,
                        child: Text("Change"),
                      ),
                    ],
                  ),
                  subtitle: selectedAddress == null
                      ? Text("Select delivery address")
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${selectedAddress!['Firstname']}, '
                            '${selectedAddress!['Housenumber']}, '
                            '${selectedAddress!['Roadname']}, '
                            '${selectedAddress!['City']}',
                      ),
                      Text(
                        '${selectedAddress!['State']} - '
                            '${selectedAddress!['Pincode']}',
                      ),
                      Text(selectedAddress!['Phonenumber']),
                    ],
                  ),
                ),
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                var item = widget.cartItems[index];
                var data = item.data() as Map<String, dynamic>;

                return Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    height: 145,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Container(
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
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data["name"]),
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
                                Icon(Icons.star,
                                    color: Colors.green, size: 15),
                                Text(
                                  (data["totalrating"]??0).toString(),
                                ),

                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  "₹${data["Price"]}",
                                  style: TextStyle(
                                    decoration:
                                    TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text("₹${data["price"]}"),
                              ],
                            ),
                            Text("Qty : ${data["quantity"]}")
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),


            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Price Details :", style: TextStyle(fontSize: 16)),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Amount",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("₹$totalAmount",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
