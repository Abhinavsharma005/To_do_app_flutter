import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/getstart.dart';
import 'package:to_do_app/login_page.dart';
import 'package:to_do_app/onboarding_page.dart';
import 'package:to_do_app/tasks_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF95FFA9),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Color(0xffF6FAFF),
        ),
      ),
      home: GetStartPage(),

    );
  }
}

