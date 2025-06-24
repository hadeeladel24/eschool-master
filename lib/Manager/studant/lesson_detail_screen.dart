import 'package:flutter/material.dart';

class LessonDetailScreen extends StatelessWidget {
  final String subject;
  final String title;

  const LessonDetailScreen({super.key, required this.subject, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الدرس'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'المادة: $subject',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Text(
              'هذا هو شرح مفصل للدرس "$title" في مادة $subject. يمكنك تخصيص هذه الصفحة لعرض محتوى الدرس مثل فيديو أو ملخص أو ملف PDF.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
