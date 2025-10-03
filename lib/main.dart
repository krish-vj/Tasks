import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_cascade_manager/providers/task_provider.dart';
import 'package:task_cascade_manager/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        title: 'Task Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.white,
          // Define card theme for a consistent look
          cardTheme: CardThemeData(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.white, width: 1),
            ),
            elevation: 0,
          ),
          // Define text theme
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
            titleLarge: TextStyle(color: Colors.white),
          ),
          // Define icon theme
          iconTheme: const IconThemeData(color: Colors.white),
          // Define dialog theme
          dialogTheme: DialogThemeData(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.white),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}