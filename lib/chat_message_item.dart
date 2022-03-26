import 'package:flutter/material.dart';

import 'src/core/model/message.dart';

class ChatMessageItem extends StatefulWidget {
  const ChatMessageItem({
    Key? key,
    required this.alignment,
    required this.message,
    required this.color,
  }) : super(key: key);

  final Alignment alignment;
  final Message message;
  final Color color;

  @override
  _ChatMessageItemState createState() => _ChatMessageItemState();
}

class _ChatMessageItemState extends State<ChatMessageItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.alignment,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.3),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: widget.message.type == 'image'
                      ? EdgeInsets.zero
                      : const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(10)),
                  child: widget.message.type == 'image'
                      ? GestureDetector(
                          onTap: () {
                            
                          },
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(widget.message.message!, fit: BoxFit.cover)),
                          ))
                      : widget.message.type == 'audio'
                          ? SizedBox(
                              width: 150,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                       
                                      },
                                      icon: const Icon(Icons.play_arrow))
                                ],
                              ),
                            )
                          : Text(
                              widget.message.message!,
                              style: const TextStyle(color: Colors.white),
                            ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
