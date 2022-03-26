import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:my_chat_app/src/core/model/conversation.dart';
import 'package:my_chat_app/src/core/repository/message_repository.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final repository = ChatRepositoryImpl();

  StreamSubscription? _subscription;

  ConversationBloc() : super(ConversationLoading()) {
    on<LoadConversations>(_onLoadConversations);
  }

  init(String id) {
    _subscription?.cancel();
    _subscription = repository.getConversations(id).listen((conversations) {
      add(LoadConversations(conversations));
    });
  }

  _onLoadConversations(
      LoadConversations event, Emitter<ConversationState> emit) {
    emit(ConversationLoaded(conversations: event.conversations));
  }
}
