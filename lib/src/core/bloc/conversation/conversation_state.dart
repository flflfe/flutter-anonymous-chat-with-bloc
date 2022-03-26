part of 'conversation_bloc.dart';

@immutable
abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

class ConversationLoading extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final List<Conversation> conversations;

  const ConversationLoaded({this.conversations = const <Conversation>[]});

  @override
  List<Object> get props => [conversations];
}
