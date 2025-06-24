import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      {'sender': 'أ. أحمد', 'message': 'يرجى مراجعة درس الرياضيات'},
      {'sender': 'أ. منى', 'message': 'تم إضافة واجب اللغة العربية'},
      {'sender': 'المدير', 'message': 'إجازة يوم الخميس'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('الرسائل'),
        backgroundColor: Colors.blue[800],
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          return ListTile(
            leading: Icon(Icons.message),
            title: Text(msg['message']!),
            subtitle: Text('من: ${msg['sender']}'),
          );
        },
      ),
    );
  }
}
