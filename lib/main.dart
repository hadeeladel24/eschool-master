import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'Manager/warpper.dart';
import  'package:get/get.dart';
//import 'role_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'مدرستي الالكترونية ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Wrapper(),
    );
  }
}


