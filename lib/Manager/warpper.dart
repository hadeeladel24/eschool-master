import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'student_home.dart';
import 'studant/student_home.dart';
import 'role_selection_screen.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
            return RoleSelectionScreen();
          }

      ),
    );
  }
}
