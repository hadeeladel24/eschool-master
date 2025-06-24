import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
<<<<<<< HEAD
=======
//import 'student_home.dart';
import 'studant/student_home.dart';
>>>>>>> 7388435705bb545d983613cec69dbd9e56f684b4
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
<<<<<<< HEAD
          }
            return RoleSelectionScreen();
          }

=======
          } else if (snapshot.hasData) {
            return StudentHomeScreen(studentEmail: snapshot.data!.email!);

          } else {
            return RoleSelectionScreen();
          }
        },
>>>>>>> 7388435705bb545d983613cec69dbd9e56f684b4
      ),
    );
  }
}
