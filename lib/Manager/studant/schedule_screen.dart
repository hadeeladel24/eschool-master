import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  final Map<String, List<String>> weeklySchedule = {
    'Sunday': ['Arabic', 'Science', 'Mathematics', 'English', 'History', 'Technology'],
    'Monday': ['Physics', 'Chemistry', 'Biology', 'Religion', 'Physical Education', 'Art'],
    'Tuesday': ['Mathematics', 'Arabic', 'Science', 'Technology', 'English', 'History'],
    'Wednesday': ['Religion', 'Physics', 'Chemistry', 'Biology', 'Physical Education', 'Art'],
    'Thursday': ['Technology', 'Mathematics', 'Arabic', 'English', 'Science', 'History'],
  };


  final List<String> periods = [
    'Period 1',
    'Period 2',
    'Period 3',
    'Period 4',
    'Period 5',
    'Period 6',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Academic schedule'),
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