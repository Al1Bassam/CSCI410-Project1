import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/quiz_provider.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Initialize the QuizProvider that manages the quiz state
      create: (_) => QuizProvider(),
      child: MaterialApp(
         debugShowCheckedModeBanner: false,
        title: 'Quiz App',
        //Styling and theme
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
       
        home: const HomeScreen(),
      ),
    );
  }
} 