import 'package:flutter/material.dart';
import 'package:quickrecruitementtask/auth/login_page.dart';
import 'package:quickrecruitementtask/home/task_home.dart';
import 'package:quickrecruitementtask/product/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task 1 & 2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: const InputDecorationTheme(
          errorStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      home: const TaskPage(),
    );
  }
}