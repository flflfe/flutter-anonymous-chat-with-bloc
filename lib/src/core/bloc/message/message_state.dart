part of 'message_bloc.dart';

@immutable
abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageLoading extends MessageState {}

class MessagesLoaded extends MessageState {
  final List<Message> messages;

  const MessagesLoaded({this.messages = const <Message>[]});
}
