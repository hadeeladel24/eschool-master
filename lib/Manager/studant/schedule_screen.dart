import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  final Map<String, List<String>> weeklySchedule = {
    'الأحد': ['عربي', 'علوم', 'رياضيات', 'إنجليزي', 'تاريخ', 'تكنولوجيا'],
    'الاثنين': ['فيزياء', 'كيمياء', 'أحياء', 'دين', 'رياضة', 'فن'],
    'الثلاثاء': ['رياضيات', 'عربي', 'علوم', 'تكنولوجيا', 'إنجليزي', 'تاريخ'],
    'الأربعاء': ['دين', 'فيزياء', 'كيمياء', 'أحياء', 'رياضة', 'فن'],
    'الخميس': ['تكنولوجيا', 'رياضيات', 'عربي', 'إنجليزي', 'علوم', 'تاريخ'],
  };

  final List<String> periods = [
    'الحصة 1',
    'الحصة 2',
    'الحصة 3',
    'الحصة 4',
    'الحصة 5',
    'الحصة 6',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الجدول الدراسي'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: ListView(
          children: weeklySchedule.entries.map((entry) {
            final day = entry.key;
            final classes = entry.value;
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              child: ExpansionTile(
                title: Text(day,
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                children: List.generate(classes.length, (index) {
                  return ListTile(
                    leading: Icon(Icons.book, color: Colors.blue[700]),
                    title: Text('${periods[index]} - ${classes[index]}'),
                  );
                }),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
