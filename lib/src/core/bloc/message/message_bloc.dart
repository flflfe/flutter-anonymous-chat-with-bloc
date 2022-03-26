import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/src/core/model/message.dart';
import 'package:my_chat_app/src/core/repository/message_repository.dart';

part 'message_state.dart';
part 'message_event.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final repository = ChatRepositoryImpl();

  MessageBloc() : super(MessageLoading()) {
    on<LoadMessages>(_onLoadMessages);

    on<UpdateMessages>(_onUpdateMessages);
  }

  _onLoadMessages(LoadMessages event, Emitter<MessageState> emit) async {
    await emit.onEach(repository.getMessages(event.id, event.conversationId),
        onData: (List<Message> list) => add(UpdateMessages(list)));
  }

  _onUpdateMessages(UpdateMessages event, Emitter<MessageState> emit) {
    emit(MessagesLoaded(messages: event.messages));
  }
}
