import 'package:flutter/material.dart';
import 'package:joke_a_minute/providers/jokes.dart';
import 'package:joke_a_minute/screens/homepage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => JokeProvider())],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            useMaterial3: true),
        home: const MyHomePage(title: 'Joke a Min'));
  }
}
