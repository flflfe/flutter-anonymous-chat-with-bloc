import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_chat_app/chat_screen.dart';
import 'package:my_chat_app/src/core/repository/message_repository.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final repository = ChatRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('userId', isNotEqualTo: widget.userId)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Container(
                color: Colors.black,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "Click user to start a conversation",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return ListTile(
                      onTap: () async {
                        await repository
                            .getConversationId(widget.userId, data['userId'])
                            .then((value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => ChatScreen(
                                receiverName: data['username'],
                                receiverId: data['userId'],
                                senderId: widget.userId,
                                currentId: widget.userId,
                                conversationId: value,
                              ),
                            ),
                          );
                        });
                      },
                      title: Text(data['username'].toString()),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
