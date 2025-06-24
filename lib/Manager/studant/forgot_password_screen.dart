import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  TextEditingController email = TextEditingController();

  Future<void> reset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("استعادة كلمة المرور"),
        backgroundColor: const Color(0xFF0D47A1),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2196F3), // أزرق فاتح
              Color(0xFF0D47A1), // أزرق غامق
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "هل نسيت كلمة المرور؟",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'أدخل بريدك الإلكتروني',
                        prefixIcon: const Icon(Icons.email, color: Colors.blue),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue.shade700, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue.shade300, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: reset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "إرسال رابط إعادة التعيين",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
