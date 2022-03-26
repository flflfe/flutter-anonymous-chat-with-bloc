import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/fake_auth.dart';
import 'package:my_chat_app/src/core/bloc/conversation/conversation_bloc.dart';
import 'package:my_chat_app/src/core/bloc/message/message_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ConversationBloc()),
        BlocProvider(create: (context) => MessageBloc()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FakeAuthScreen(),
      ),
    );
  }
}
