import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/chat_message_item.dart';
import 'package:my_chat_app/src/core/bloc/message/message_bloc.dart';
import 'package:my_chat_app/src/core/model/message.dart';
import 'package:my_chat_app/src/core/repository/message_repository.dart';
import 'package:my_chat_app/src/ui/message_input.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    Key? key,
    required this.currentId,
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
    this.conversationId,
  }) : super(key: key);

  final String currentId;
  final String senderId;
  final String receiverId;
  final String receiverName;
  String? conversationId;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final repo = ChatRepositoryImpl();

  String? docId;

  ScrollController scrollController = ScrollController();
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    context.read<MessageBloc>().add(LoadMessages(widget.currentId, widget.conversationId!));
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildMsgListWithStreamBuilder(),
            MessageInput(
              conversationId: widget.conversationId!,
              senderId: widget.senderId,
              receiverId: widget.receiverId,
            ),
          ],
        ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      foregroundColor: Colors.black,
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.red.withOpacity(.2),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.receiverName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      titleSpacing: 0,
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
      ],
    );
  }

  _buildMsgListWithStreamBuilder() {
    return Expanded(
      child: StreamBuilder(
        stream: repo.getMessages(widget.currentId, widget.conversationId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Message> list = snapshot.data as List<Message>;

            if (list.isEmpty) {
              return const Center(child: Text("no messages"));
            }
            
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final msg = list[index];
                return ChatMessageItem(
                  alignment: msg.senderId == widget.senderId
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  color: msg.senderId == widget.senderId
                      ? const Color(0xff54BAB9)
                      : const Color(0xff7C99AC),
                  message: msg,
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  _buildMsgListWithBlocBuilder() {
    return Expanded(
      child: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          if (state is MessageLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MessagesLoaded) {
            if (state.messages.isEmpty) {
              return const Center(child: Text("no messages"));
            }

            return ListView.builder(
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final msg = state.messages[index];
                return ChatMessageItem(
                  alignment: msg.senderId == widget.senderId
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  color: msg.senderId == widget.senderId
                      ? const Color(0xff54BAB9)
                      : const Color(0xff7C99AC),
                  message: msg,
                );
              },
            );
          }

          return const Center(child: Text("error"));
        },
      ),
    );
  }
}
