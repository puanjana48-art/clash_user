import 'package:carousel_slider/carousel_slider.dart';
import 'package:clashproject/accountpage/Accountpage.dart';
import 'package:clashproject/cartpage/cartpage.dart';
import 'package:clashproject/homepage/pagefrock.dart';
import 'package:clashproject/homepage/pagekurthi.dart';
import 'package:clashproject/homepage/searchpage.dart';
import 'package:clashproject/authentication/splashpage.dart';
import 'package:clashproject/wishlistpage/wishlistpage.dart';
import 'package:clashproject/homepage/sugdetail1.dart';
import 'package:clashproject/homepage/pageTop.dart';
import 'package:clashproject/homepage/pageshirt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  List img =[
    'lib/images/topwhite.jpg',
    'lib/images/tshirt.jpg',
    'lib/images/girlfrock.jpg',
    'lib/images/kurthi.jpg',
    ];
  List names=[
    'Tops',
    'shirts',
    'Girls frocks',
    'Kurtis',
  ];
  List sugnames=[
    'Res peplum kurti...',
    'Saree with Green Zari..',
    'Georgette Anarkali...',
    'Striped Flared Kurta..'
  ];

  List sugprice=[
    ' ₹259',
    ' ₹700',
    ' ₹476',
    ' ₹2400'
  ];
  List sugprice2=[
    '₹240',
    '₹690',
    '₹436',
    '₹2223'
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Cartpg(),));
            },
                icon: Icon(Icons.shopping_cart,color: Colors.purple.shade100,)
            )],
          backgroundColor: Colors.blueGrey.shade800,
           title: Row(
            children: [
               Icon(Icons.handshake_sharp,color: Colors.purple.shade100,),
              SizedBox(width: 5),
               Text('C L A S H',style: TextStyle(color:Colors.purple.shade100,fontWeight: FontWeight.bold,),),
             ],
           ),
         ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(

                readOnly: true,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Search(),));

                },
                decoration: InputDecoration(
                  hintText: "Search for products",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey.shade800),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            CarouselSlider(
                items: [
                  Container(
                    height: 250,
                    width: 450,
                    decoration:BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('lib/images/ads.jpg'),fit: BoxFit.cover)
                    ),
                  ),
                  Container(
                    height: 250,
                    width: 450,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage('lib/images/female style.jpg'),fit: BoxFit.cover)                  ),

                  ),
                  Container(
                    height: 250,
                    width: 450,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage('lib/images/mad.jpg'),fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    height: 250,
                    width: 450,
                    decoration:BoxDecoration(
                      image:DecorationImage(image:AssetImage('lib/images/men.jpg'),fit:BoxFit.cover)
                    )
                  ),
                  Container(
                    height: 250,
                    width: 450,
                   decoration: BoxDecoration(
                     image: DecorationImage(image: AssetImage('lib/images/girls.jpg'),fit: BoxFit.cover)
                   ),
                  ),
                ],
                options: CarouselOptions(
                  height: 150,
                  initialPage: 1,

                  autoPlay: true,
                  autoPlayAnimationDuration: Duration(
                    seconds: 1,
                  ),
                  aspectRatio: 500/2,
                  viewportFraction: 0.8,
                  enlargeCenterPage: true
                )),
            SizedBox(height: 8),
            Text('Suggested for You',style: TextStyle(color: Colors.black),),
        SizedBox(
          height: 500,
          child: SizedBox(
            height: 500,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .doc('suggestions')
                  .collection('items')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var items = snapshot.data!.docs;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    var item = items[index];

                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Sug1(
                                category: "suggestions",
                                productId: item.id,
                              ),
                            ),
                          );

                        },
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              width: 120,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueGrey.shade800,
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  )
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(item['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              item['name'].length>35
                              ?'${item['name'].substring(0,35)}...'
                              :item['name'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                              "₹${item['Price']}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text("₹${item['price']}"),

                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )

        ) ,

            Text('Categories',style: TextStyle(color: Colors.black),),
            Container(
              height: 190,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: img.length,
                // itemExtent: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10,left: 10,right: 10,top: 4),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)
                                {
                                  switch(index){
                                    case 0:
                                      return Tops();
                                    case 1:
                                      return Shirtpage();
                                    case 2:
                                      return Frocks();

                                    case 3:
                                      return Kurthi();
                                    default:
                                      return Container();
                                  }
                                },));},
                              child: Container(
                                height: 160,
                                width: 100,
                                color: Colors.grey.shade300,
                                child:  Column(
                                  children: [
                                    SizedBox(height: 6),
                                    Container(
                                      width: 70,
                                      height: 90,
                                      decoration: BoxDecoration(
                                          borderRadius:BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10),topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.blueGrey.shade800,
                                                spreadRadius: 3,
                                                blurRadius: 6,
                                                offset: Offset(0, 3)
                                            )
                                          ],
                                          image: DecorationImage(image: AssetImage(img[index]),fit: BoxFit.cover)
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(names[index],style: TextStyle(color: Colors.grey.shade600),),
                                    SizedBox(
                                        height: 36,
                                        child: TextButton(onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)  {
                                            switch(index){
                                              case 0:
                                                return Tops();
                                              case 1:
                                                return Shirtpage();
                                              case 2:
                                                return Frocks();

                                              case 3:
                                                return Kurthi();
                                              default:
                                                return Container();
                                            }
                                          }));
                                        }, child: Text('view Store',style: TextStyle(color: Colors.black),)))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Text(names[index],style: TextStyle(color: Colors.grey.shade600),),
                      ],
                    ),
                  );
                },),
            ),
          ],
        ),
      ),
    );

  }
}
