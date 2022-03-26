part of 'message_bloc.dart';

@immutable
abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class LoadMessages extends MessageEvent {
  final String id;
  final String conversationId;

  const LoadMessages(this.id, this.conversationId);

  @override
  List<Object> get props => [id, conversationId];
}

class UpdateMessages extends MessageEvent {
  final List<Message> messages;

  const UpdateMessages(this.messages);
  
  @override
  List<Object> get props => [messages];
}
