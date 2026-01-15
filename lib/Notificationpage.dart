import 'package:flutter/material.dart';

class Messege extends StatefulWidget {
  const Messege({super.key});

  @override
  State<Messege> createState() => _MessegeState();
}

class _MessegeState extends State<Messege> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.grey.shade300,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon:Icon(Icons.arrow_back)),
        backgroundColor: Colors.blueGrey.shade400,
      ),
    );
  }
}
