import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statemanagment/chatPage.dart';

void main() {
  runApp(ChatApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChatApp();
  }
}

