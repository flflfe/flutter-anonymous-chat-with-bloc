import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String? type;
  String? convId;
  String? senderId;
  String? message;
  List<String>? notDeletedFrom;

  Message({
    required this.id,
    this.type,
    this.senderId,
    this.message,
    this.convId,
    this.notDeletedFrom,
  });

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      id: doc.id,
      type: doc['type'],
      message: doc['msg'],
      senderId: doc['senderId'],
      convId: doc['conversationId'],
      notDeletedFrom: List<String>.from(doc['notDeletedFrom']),
    );
  }
}
