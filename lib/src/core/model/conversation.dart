import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  String id;
  String? senderId;
  String? receiverId;
  List<String>? users;
  List<String>? notDeletedFrom;
  String? anonKey;
  String? lastMessage;
  String? receiverName;
  int? pairCode;

  Conversation({
    required this.id,
    this.notDeletedFrom,
    this.senderId,
    this.receiverId,
    this.anonKey,
    this.lastMessage,
    this.pairCode,
    this.receiverName,
    this.users,
  });

  factory Conversation.fromDocument(DocumentSnapshot doc) {
    return Conversation(
      id: doc.id,
      senderId: doc['senderId'],
      receiverId: doc['receiverId'],
      anonKey: doc['anonKey'],
      lastMessage: doc['lastMessage'],
      pairCode: doc['pairCode'],
      receiverName: doc['receiverName'],
      users: List<String>.from(doc['users']),
      notDeletedFrom: List<String>.from(doc['notDeletedFrom']),
    );
  }
}
