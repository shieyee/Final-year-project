import 'package:flutter/material.dart';
import 'package:tams/view/screens/splashscreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tender and Asset Management System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(

      primary:  Color.fromARGB(255, 223, 205, 160),
      secondary:  Color.fromARGB(255, 223, 205, 160),
      ),
      ),
      home: const SplashScreen(),
    );
  }
}
