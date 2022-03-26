import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/src/core/bloc/conversation/conversation_bloc.dart';
import 'package:my_chat_app/src/core/model/conversation.dart';
import 'package:my_chat_app/src/core/repository/message_repository.dart';

import 'chat_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final repository = ChatRepositoryImpl();

  @override
  void initState() {
    BlocProvider.of<ConversationBloc>(context).init(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
        elevation: 0,
      ),
      body: _buildChatHistoryWithStreamBuilder(),
    );
  }

  _buildChatHistoryWithBlocBuilder() {
    return BlocBuilder<ConversationBloc, ConversationState>(
      builder: (context, state) {
        if (state is ConversationLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ConversationLoaded) {
          final list = state.conversations;

          if (list.isEmpty) {
            return const Center(child: Text("No chat history"));
          }

          return Column(
            children: [
              Container(
                color: Colors.black,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "Long press a conversation to delete it",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final conversation = list[index];
                    final anonId = conversation.anonKey;
                    final recId = conversation.users![1];
                    final senId = conversation.users![0];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            conversation.getAvatarColor(widget.id, index),
                        child: Text(conversation.getAvatarText(widget.id)),
                        foregroundColor: Colors.white,
                      ),
                      //dense: true,
                      title: Text(
                        recId == widget.id
                            ? anonId!
                            : conversation.receiverName!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          conversation.lastMessage!.contains('http')
                              ? '[media]'
                              : conversation.lastMessage!,
                          overflow: TextOverflow.ellipsis),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => ChatScreen(
                                  conversationId: conversation.id,
                                  currentId: widget.id,
                                  senderId: recId == widget.id ? recId : senId,
                                  receiverId:
                                      recId == widget.id ? senId : recId,
                                  receiverName: recId == widget.id
                                      ? anonId!
                                      : conversation.receiverName!,
                                )),
                          ),
                        );
                      },
                      onLongPress: () {
                        repository.deleteChat(widget.id, conversation);
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const Center(child: Text("error"));
      },
    );
  }

  _buildChatHistoryWithStreamBuilder() {
    return StreamBuilder(
      stream: repository.getConversations(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          final list = snapshot.data as List<Conversation>;

          if (list.isEmpty) {
            return const Center(child: Text("no chat history"));
          }

          return Column(
            children: [
              Container(
                color: Colors.black,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "Long press a conversation to delete it",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final conversation = list[index];
                    final anonId = conversation.anonKey;
                    final recId = conversation.users![1];
                    final senId = conversation.users![0];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            conversation.getAvatarColor(widget.id, index),
                        child: Text(conversation.getAvatarText(widget.id)),
                        foregroundColor: Colors.white,
                      ),
                      //dense: true,
                      title: Text(
                        recId == widget.id
                            ? anonId!
                            : conversation.receiverName!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          conversation.lastMessage!.contains('http')
                              ? '[media]'
                              : conversation.lastMessage!,
                          overflow: TextOverflow.ellipsis),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => ChatScreen(
                                  conversationId: conversation.id,
                                  currentId: widget.id,
                                  senderId: recId == widget.id ? recId : senId,
                                  receiverId:
                                      recId == widget.id ? senId : recId,
                                  receiverName: recId == widget.id
                                      ? anonId!
                                      : conversation.receiverName!,
                                )),
                          ),
                        );
                      },
                      onLongPress: () {
                        repository.deleteChat(widget.id, conversation);
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const Center(child: Text("an error occured"));
      },
    );
  }
}

extension ChatListExtension on Conversation {
  String getAvatarText(String s) {
    return users![1] == s ? '?' : receiverName!.substring(0, 1).toUpperCase();
  }

  Color getAvatarColor(String s, int index) {
    return users![1] != s ? Colors.redAccent : Colors.grey;
  }
}
