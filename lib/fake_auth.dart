import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/user_home.dart';

class FakeAuthScreen extends StatefulWidget {
  const FakeAuthScreen({Key? key}) : super(key: key);

  @override
  _FakeAuthScreenState createState() => _FakeAuthScreenState();
}

class _FakeAuthScreenState extends State<FakeAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Center(
            child: Text(
              "LOGIN AS",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () => goHome("2222"), child: const Text("John")),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () => goHome("0000"), child: const Text("Mark")),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () => goHome("1111"), child: const Text("Mary")),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () => goHome("3333"), child: const Text("Kate")),
          ),
        ],
      ),
    );
  }

  goHome(String id) async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: id)
        .get();

    final data = user.docs.first.data();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => UserHome(data['userId'])));
  }
}
