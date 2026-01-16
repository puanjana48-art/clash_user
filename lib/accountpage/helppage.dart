import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpcentre extends StatefulWidget {
  const Helpcentre({super.key});

  @override
  State<Helpcentre> createState() => _HelpcentreState();
}

class _HelpcentreState extends State<Helpcentre> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.grey.shade300,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon:Icon(Icons.arrow_back,color: Colors.purple.shade100)),
        backgroundColor: Colors.blueGrey.shade400,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
           Padding(
             padding: const EdgeInsets.all(4.0),
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
                  child:TextButton(
                      onPressed: ()async{
                        final url=Uri(
                          scheme: 'tel',
                          path: '9605865325'
                        );
                        if(await canLaunchUrl(url)){
                          await launchUrl(url);
                        }

                      },
                      child:Row(
                        children: [
                          Icon(Icons.call,size: 16,),
                          SizedBox(width: 6),
                          Text('We are here for you Contact us',style: TextStyle(fontSize: 16),),
                        ],
                      ))
              ),
           ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(4.0),
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
                child:TextButton(
                    onPressed: ()async{
                      final url =Uri(
                          scheme: 'sms',
                          path: '9605865325'
                      );
                      if(await canLaunchUrl(url)){
                        await launchUrl(url);
                      }

                    },
                    child:Row(
                      children: [
                        Icon(Icons.message_outlined,size: 16,),
                        SizedBox(width: 6),
                        Text('Send a SMS',style: TextStyle(fontSize: 16),),
                      ],
                    ))
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(4.0),
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
                child:TextButton(
                    onPressed: ()async{
                      final url=Uri(
                        scheme: 'mailto',
                        path: 'puanjana48@gmail.com',
                        queryParameters: {
                          'Subject':'Request letter',
                          'body':'Respected sir'
                        }
                      );
                      if(await canLaunchUrl(url)){
                        await launchUrl(url);
                      }

                    },
                    child:Row(
                      children: [
                        Icon(Icons.mail,size: 16,),
                        SizedBox(width: 6),
                        Text('Mail Us',style: TextStyle(fontSize: 16),),
                      ],
                    ))
            ),
          ),


        ],
      ),
    );
  }
}
