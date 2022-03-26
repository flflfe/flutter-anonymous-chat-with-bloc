import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:my_chat_app/src/core/model/conversation.dart';
import 'package:my_chat_app/src/core/model/message.dart';
import 'package:my_chat_app/src/core/util/shared.dart';
import 'package:uuid/uuid.dart';
import 'dart:async' show Stream;
import 'package:async/async.dart' show StreamGroup;

abstract class ChatRepository {
  Stream<List<Conversation>> getConversations(String id);

  Stream<List<Message>> getMessages(String id, String? docId);

  Future<String> getConversationId(String senderId, String receiverId);

  void addMessage(
    String? docId,
    String sender,
    String receiver,
    String message,
    MessageType type,
  );

  void deleteChat(String userId, Conversation conversation);

  void deleteMessage(String? msgId, String userId);
}

class ChatRepositoryImpl implements ChatRepository {
  late CollectionReference conversations;
  late CollectionReference messages;

  ChatRepositoryImpl() {
    conversations = FirebaseFirestore.instance.collection('conversation');
    messages = FirebaseFirestore.instance.collection('messages');
  }

  @override
  Stream<List<Conversation>> getConversations(String id) {
    Stream<List<Conversation>> stream1 = conversations
        .where('users', arrayContainsAny: [id])
        .snapshots()
        .map((query) => List<Conversation>.from(
            query.docs.map((e) => Conversation.fromDocument(e))));

    Stream<List<Conversation>> stream2 = conversations
        .where('notDeletedFrom', arrayContains: id)
        .snapshots()
        .map((query) => List<Conversation>.from(
            query.docs.map((e) => Conversation.fromDocument(e))));

    return StreamGroup.merge([stream1, stream2]);
  }

  @override
  Stream<List<Message>> getMessages(String id, String? conversationId) {
    return messages
        .where('conversationId', isEqualTo: conversationId)
        .where('notDeletedFrom', arrayContainsAny: [id])
        .orderBy('createdOn', descending: false)
        .snapshots()
        .map((query) =>
            List<Message>.from(query.docs.map((e) => Message.fromDocument(e))));
  }

  @override
  void addMessage(String? conversationId, String sender, String receiver,
      String message, MessageType type) async {
    messages.add({
      'conversationId': conversationId,
      'senderId': sender,
      'receiverId': receiver,
      'msg': message,
      'type': describeEnum(type),
      'createdOn': FieldValue.serverTimestamp(),
      'notDeletedFrom': [sender, receiver],
    }).then((value) async {
      conversations.doc(conversationId).update({
        'lastMessage': message,
        'notDeletedFrom': [sender, receiver],
      });
    });
  }

  @override
  Future<String> getConversationId(String senderId, String receiverId) async {
    final hashSum = senderId.hashCode + receiverId.hashCode;
    final res = await conversations.where('pairCode', isEqualTo: hashSum).get();
    if (res.docs.isEmpty) {
      return await initConversation(senderId, receiverId);
    } else {
      final existing = await conversations
          .where('users', isEqualTo: [senderId, receiverId]).get();
      if (existing.docs.isNotEmpty) {
        final data = existing.docs.first.data() as Map<String, dynamic>;
        List<String> visibleTo = List.from(data['notDeletedFrom']);
        visibleTo
          ..clear()
          ..addAll([senderId, receiverId]);
        conversations
            .doc(existing.docs.first.id)
            .update({'notDeletedFrom': visibleTo});
        return existing.docs.first.id;
      } else {
        return await initConversation(senderId, receiverId);
      }
    }
  }

  Future<String> initConversation(String senderId, String receiverId) async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: receiverId)
        .get();

    final userData = user.docs.first.data();

    final hashSum = senderId.hashCode + receiverId.hashCode;
    final result = await conversations.add({
      'senderId': senderId,
      'receiverId': receiverId,
      'anonKey': const Uuid().v5(Uuid.NAMESPACE_URL, senderId),
      'users': [senderId, receiverId],
      'notDeletedFrom': [senderId, receiverId],
      'receiverName': userData['username'],
      'lastMessage': '',
      'pairCode': hashSum,
      'time': FieldValue.serverTimestamp(),
    });
    return result.id;
  }

  @override
  void deleteChat(String userId, Conversation conversation) async {
    List<String> visibleList = conversation.notDeletedFrom!;
    if (visibleList.length == 2) {
      visibleList.remove(userId);
      conversations
          .doc(conversation.id)
          .update({'notDeletedFrom': visibleList});
      deleteMessagesFromOne(conversation.id, userId);
    } else {
      visibleList.clear();
      conversations.doc(conversation.id).delete();
      deleteMessagesFromBoth(conversation.id);
    }
  }

  @override
  void deleteMessage(String? msgId, String userId) {}

  void deleteMessagesFromOne(String convId, String userId) {
    messages.where('conversationId', isEqualTo: convId).get().then((snapshot) {
      for (var document in snapshot.docs) {
        final data = document.data() as Map<String, dynamic>;
        final visibleTo = List<String>.from(data['notDeletedFrom']);
        visibleTo.removeWhere((element) => element == userId);
        document.reference.update({'notDeletedFrom': visibleTo});
      }
    });
  }

  void deleteMessagesFromBoth(String convId) {
    messages.where('conversationId', isEqualTo: convId).get().then((snapshot) {
      for (var document in snapshot.docs) {
        document.reference.delete();
      }
    });
  }
}
