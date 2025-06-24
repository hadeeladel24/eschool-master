import 'package:flutter/material.dart';
import 'lesson_detail_screen.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> lessons = [
      {'subject': 'الرياضيات', 'title': 'الدوال التربيعية', 'color': Colors.red},
      {'subject': 'اللغة العربية', 'title': 'بلاغة التشبيه', 'color': Colors.green},
      {'subject': 'العلوم', 'title': 'دورة الماء في الطبيعة', 'color': Colors.blue},
      {'subject': 'الإنجليزي', 'title': 'Present Perfect Tense', 'color': Colors.orange},
      {'subject': 'التاريخ', 'title': 'الحضارات القديمة', 'color': Colors.brown},
      {'subject': 'التكنولوجيا', 'title': 'أنظمة التشغيل', 'color': Colors.teal},
      {'subject': 'الفيزياء', 'title': 'قانون نيوتن الثاني', 'color': Colors.purple},
      {'subject': 'الكيمياء', 'title': 'الروابط الكيميائية', 'color': Colors.deepOrange},
      {'subject': 'الأحياء', 'title': 'الخلايا النباتية', 'color': Colors.indigo},
      {'subject': 'الدين', 'title': 'سورة الكهف', 'color': Colors.deepPurple},
      {'subject': 'الرياضة', 'title': 'قواعد كرة السلة', 'color': Colors.lightGreen},
      {'subject': 'الفن', 'title': 'المنظور في الرسم', 'color': Colors.pink},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('الدروس'),
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
                  'المادة: ${lesson['subject'] as String}',
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
