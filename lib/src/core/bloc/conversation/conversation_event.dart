part of 'conversation_bloc.dart';

@immutable
abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object> get props => [];
}

class LoadConversations extends ConversationEvent {
  final List<Conversation> conversations;

  const LoadConversations(this.conversations);

  @override
  List<Object> get props => [conversations];
}
