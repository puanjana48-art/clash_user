import 'package:clashproject/cartpage.dart';
import 'package:clashproject/page1.dart';
import 'package:clashproject/productpage.dart';
import 'package:clashproject/wishpage2.dart';
import 'package:flutter/material.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.grey.shade300,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Cartpg(),));
          },
              icon: Icon(Icons.shopping_cart,color: Colors.purple.shade100,)
          )],
        title: Text('My wishlist',style: TextStyle(color:Colors.purple.shade100,fontWeight: FontWeight.bold,)),
        backgroundColor: Colors.blueGrey.shade600,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Wish2()));
            },
            child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
            color: Colors.grey.shade300,
            boxShadow: [
              BoxShadow(
                  color: Colors.blueGrey.shade800,
                  spreadRadius: 3,
                  blurRadius: 6,
                  offset: Offset(0, 3)
              )
            ],
                    ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20,left: 5),
                child: Text('My wishlist',style: TextStyle(color: Colors.black),),
              ),
            ),
          )
        ],
      ),

    );
  }
}
