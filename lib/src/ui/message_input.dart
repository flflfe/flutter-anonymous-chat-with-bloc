import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/font/custom_icons_icons.dart';
import 'package:my_chat_app/src/core/repository/message_repository.dart';

import '../core/bloc/message/message_bloc.dart';
import '../core/util/shared.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({
    required this.senderId,
    required this.receiverId,
    required this.conversationId,
    Key? key,
  }) : super(key: key);

  final String senderId;
  final String receiverId;
  final String conversationId;

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final repository = ChatRepositoryImpl();
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<MessageBloc>(context),
      builder: (context, MessageState messageState) {
        return Container(
          color: const Color(0xffEEEEEE),
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xffEEEEEE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (widget, animation) => ScaleTransition(
                      scale: animation,
                      child: widget,
                    ),
                    child: Row(
                      key: const ValueKey<int>(23),
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: null,
                            controller: _textController,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(left: 5),
                                border: InputBorder.none,
                                hintText: 'Type something...'),
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            iconSize: 20,
                            color: Colors.grey,
                            icon: const Icon(CustomIcons.camera))
                      ],
                    ),
                  ),
                ),
              ),
              _sendTextButton(),
            ],
          ),
        );
      },
    );
  }

  _sendTextButton() {
    return IconButton(
      onPressed: () {
        repository.addMessage(
          widget.conversationId,
          widget.senderId,
          widget.receiverId,
          _textController.text,
          MessageType.text,
        );
        setState(() {});
      },
      icon: const Icon(
        CustomIcons.right,
        color: Colors.black,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
