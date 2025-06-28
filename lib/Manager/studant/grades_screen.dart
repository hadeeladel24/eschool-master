import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class GradesScreen extends StatefulWidget {
  final String classId;
  final int studentId;

  const GradesScreen({
    super.key,
    required this.classId,
    required this.studentId,
  });

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  final database = FirebaseDatabase.instance.ref();

  Map<String, int> studentGrades = {};
  bool loading = true;
  bool hasGrades = false;

  @override
  void initState() {
    super.initState();
    fetchGrades();
  }

  Future<void> fetchGrades() async {
    try {
      final snapshot =
      await database.child('grades').child(widget.classId.trim()).get();

      if (!snapshot.exists) {
        setState(() {
          loading = false;
          hasGrades = false;
        });
        return;
      }

      final data = snapshot.value;
      Map<String, int> loadedGrades = {};

      if (data is Map) {
        for (var subjectEntry in data.entries) {
          final subject = subjectEntry.key;
          final subjectValue = subjectEntry.value;

          if (subjectValue is Map) {
            final studentKey = widget.studentId.toString();
            final studentData = subjectValue[studentKey];

            if (studentData != null &&
                studentData is Map &&
                studentData.containsKey('grade')) {
              final gradeVal = studentData['grade'];
              int grade = _parseGrade(gradeVal);
              loadedGrades[subject] = grade;
            }

          } else if (subjectValue is List) {
            final index = widget.studentId;
            if (index >= 0 && index < subjectValue.length) {
              final studentData = subjectValue[index];
              if (studentData is Map && studentData.containsKey('grade')) {
                final gradeVal = studentData['grade'];
                int grade = _parseGrade(gradeVal);
                loadedGrades[subject] = grade;
              }
            }
          }
        }
      }

      setState(() {
        studentGrades = loadedGrades;
        hasGrades = loadedGrades.isNotEmpty;
        loading = false;
      });
    } catch (e) {
      print(' error : $e');
      setState(() {
        loading = false;
        hasGrades = false;
      });
    }
  }

  int _parseGrade(dynamic gradeVal) {
    if (gradeVal is int) return gradeVal;
    if (gradeVal is String) return int.tryParse(gradeVal) ?? 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grades')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : hasGrades
          ? ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: studentGrades.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final subject = studentGrades.keys.elementAt(index);
          final grade = studentGrades[subject]!;
          return ListTile(
            title: Text(
              subject,
              style: const TextStyle(fontSize: 18),
            ),
            trailing: Text(
              '$grade',
              style: const TextStyle(fontSize: 16),
            ),
          );
        },
      )
          : const Center(
        child: Text(' No Grade found for this student'),
      ),
    );
  }
}