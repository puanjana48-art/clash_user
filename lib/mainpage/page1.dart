import 'package:clashproject/accountpage/Accountpage.dart';
import 'package:clashproject/cartpage/cartpage.dart';
import 'package:clashproject/wishlistpage/wishlistpage.dart';
import 'package:clashproject/orderspage/orderpage.dart';
import 'package:clashproject/homepage/productpage.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  int selected=0;
  List pages=[
    Product(),
    Favourite(),
    Account(),
    Orderpage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.grey.shade300,
      bottomNavigationBar: CurvedNavigationBar(
        height: 56,
        backgroundColor:Colors.grey.shade300,
        color:Colors.blueGrey.shade800,
        //more adjustments
        items:[
         Icon(Icons.home_sharp,color: Colors.purple.shade100,),
            Icon(Icons.favorite_border,color: Colors.purple.shade100,),
           Icon(Icons.account_circle,color: Colors.purple.shade100,),
       Icon(Icons.card_giftcard,color: Colors.purple.shade100,),
        ],
        onTap: (index){
          setState(() {
            selected=index;
          });
        },
      ),
      body:  pages[selected],
    );
  }
}
