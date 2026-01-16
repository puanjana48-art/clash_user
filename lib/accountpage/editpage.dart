
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Edit extends StatefulWidget {
  const Edit({super.key});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController Firstname = TextEditingController();
  TextEditingController Lastname = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController emailId = TextEditingController();

  late String uid;
  late DocumentReference profileRef;

  String? selectedGender;

  @override
  void initState() {
    super.initState();

    uid = FirebaseAuth.instance.currentUser!.uid;

    profileRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('profile')
        .doc(uid);

    loadProfile();
  }


  Future<void> saveProfile() async {
    await profileRef.set({
      'name': '${Firstname.text} ${Lastname.text}',
      'phone': phonenumber.text,
      'email': emailId.text,
      'gender': selectedGender,
    }, SetOptions(merge: true));
  }


  Future<void> loadProfile() async {
    final doc = await profileRef.get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;

      final fullName = (data['name'] ?? '').toString().split(' ');
      Firstname.text = fullName.isNotEmpty ? fullName.first : '';
      Lastname.text = fullName.length > 1 ? fullName.sublist(1).join(' ') : '';

      phonenumber.text = data['phone'] ?? '';
      emailId.text = data['email'] ?? '';
      selectedGender = data['gender'];

      setState(() {});
    }
  }


  Widget avatarSelector() {
    if (selectedGender == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => setState(() => selectedGender = 'boy'),
            child: const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('lib/images/boy.jpg'),
            ),
          ),
          const SizedBox(width: 30),
          const Text('or', style: TextStyle(color: Colors.white)),
          const SizedBox(width: 30),
          GestureDetector(
            onTap: () => setState(() => selectedGender = 'girl'),
            child: const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('lib/images/Sk.jpg'),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () => setState(() => selectedGender = null),
      child: CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage(
          selectedGender == 'girl'
              ? 'lib/images/Sk.jpg'
              : 'lib/images/boy.jpg',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon:  Icon(Icons.arrow_back,color: Colors.purple.shade100),
        ),
        backgroundColor: Colors.blueGrey.shade500,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 230,
              width: double.infinity,
              color: Colors.blueGrey.shade500,
              child: Center(child: avatarSelector()),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: Firstname,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: Lastname,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: phonenumber,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Mobile Number'),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: emailId,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 30),

            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.blueGrey.shade500),
              onPressed: () async {
                await saveProfile();
                Navigator.pop(context);
              },
              child: Text('Submit',style: TextStyle(color: Colors.grey.shade200,fontSize: 15),),
            ),
          ],
        ),
      ),
    );
  }
}
