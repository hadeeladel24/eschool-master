import'package:flutter/material.dart';

class LessonDetailScreen extends StatelessWidget {
  final String subject;
  final String title;

  const LessonDetailScreen({super.key, required this.subject, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lesson details'),
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
              'subject: $subject',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Text(
              'This is a detailed explanation of the lesson. "$title" in subject $subject. You can customize this page to display lesson content such as a video, summary, or PDF file.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}