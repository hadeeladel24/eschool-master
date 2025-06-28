import 'package:flutter/material.dart';
import 'lesson_detail_screen.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> lessons = [
      {'subject': 'Mathematics', 'title': 'Quadratic Functions', 'color': Colors.red},
      {'subject': 'Arabic Language', 'title': 'Simile in Rhetoric', 'color': Colors.green},
      {'subject': 'Science', 'title': 'The Water Cycle in Nature', 'color': Colors.blue},
      {'subject': 'English', 'title': 'Present Perfect Tense', 'color': Colors.orange},
      {'subject': 'History', 'title': 'Ancient Civilizations', 'color': Colors.brown},
      {'subject': 'Technology', 'title': 'Operating Systems', 'color': Colors.teal},
      {'subject': 'Physics', 'title': 'Newton’s Second Law', 'color': Colors.purple},
      {'subject': 'Chemistry', 'title': 'Chemical Bonds', 'color': Colors.deepOrange},
      {'subject': 'Biology', 'title': 'Plant Cells', 'color': Colors.indigo},
      {'subject': 'Religion', 'title': 'Surah Al-Kahf', 'color': Colors.deepPurple},
      {'subject': 'Physical Education', 'title': 'Basketball Rules', 'color': Colors.lightGreen},
      {'subject': 'Art', 'title': 'Perspective in Drawing', 'color': Colors.pink},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('lessons'),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                leading: CircleAvatar(
                  backgroundColor: lesson['color'] as Color,
                  child: Icon(Icons.book, color: Colors.white),
                ),
                title: Text(
                  lesson['title'] as String,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'subject: ${lesson['subject'] as String}',
                  style: TextStyle(fontSize: 15),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonDetailScreen(
                        subject: lesson['subject'],
                        title: lesson['title'],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}