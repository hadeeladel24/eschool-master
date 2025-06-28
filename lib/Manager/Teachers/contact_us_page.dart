import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {

  final messageController = TextEditingController();
  final database = FirebaseDatabase.instance.ref().child("Messages");
  final _formKey = GlobalKey<FormState>();
  final userId = FirebaseAuth.instance.currentUser?.uid;

  void sendMessage(String messageText) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      print("User not logged in");
      return;
    }

    final messageRef = FirebaseDatabase.instance.ref().child('messages/$userId');

    await messageRef.push().set({
      'message': messageText,
      'timestamp': DateTime.now().toIso8601String(),
    });

    print("Message sent");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Contact Us", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(16),
        child: Column(
          children: [

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: ListTile(
                leading:  Icon(Icons.email, color: Colors.blueAccent),
                title:  Text(" SchoolManagmentSys@School.edu"),
              ),
            ),
             SizedBox(height: 10),

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: ListTile(
                leading:  Icon(Icons.phone, color: Colors.green),
                title:  Text(" Phone number : +970 599 123 456"),
              ),
            ),
             SizedBox(height: 20),

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 5,
              child: Padding(
                padding:  EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        "Send us a message",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                       SizedBox(height: 12),
                      TextFormField(
                        controller: messageController,
                        decoration:  InputDecoration(
                          labelText: "Write Your Message",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 4,
                        validator: (val) => val == null || val.isEmpty ? "Enter your message" : null,
                      ),
                       SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              sendMessage(messageController.text.trim());
                              ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(content: Text("Message sent successfully!")),
                              );
                              messageController.clear();
                            }
                          },
                          icon:  Icon(Icons.send),
                          label:  Text("Send Message"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
