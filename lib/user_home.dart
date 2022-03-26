import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/users_screen.dart';

import 'chats_screen.dart';

class UserHome extends StatefulWidget {
  const UserHome(this.id, {Key? key}) : super(key: key);

  final String id;

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: goChatHistories,
                child: const Text("See chat histories")),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: seeUsers, child: const Text("See users")),
          ),
        ],
      ),
    );
  }

  seeUsers() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => UsersPage(userId: widget.id)));
  }

  goChatHistories() async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: widget.id)
        .get();

    final data = user.docs.first.data();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatsScreen(id: data['userId'])));
  }
}
