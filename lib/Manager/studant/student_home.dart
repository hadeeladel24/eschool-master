import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'login_screen.dart';
import 'grades_screen.dart';
import 'schedule_screen.dart';
import 'lessons_screen.dart';
import 'attendance_screen.dart';     

class StudentHomeScreen extends StatefulWidget {
  final String studentEmail;

  const StudentHomeScreen({super.key, required this.studentEmail});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final database = FirebaseDatabase.instance.ref();
  String? studentName;
  String? studentClass;
  int? studentId;

  @override
  void initState() {
    super.initState();
    fetchStudentInfo();
  }

  Future<void> fetchStudentInfo() async {
    final snapshot = await database.child('Students').get();

    if (snapshot.exists) {
      final data = snapshot.value;
      if (data is List) {
        for (var value in data) {
          if (value == null) continue;
          final emailInDb = value['email']?.toString().trim();
          if (emailInDb == widget.studentEmail.trim()) {
            setState(() {
              studentName = "${value['first_name'] ?? ''} ${value['last_name'] ?? ''}".trim();
              studentClass = value['class_id'] ?? 'غير معروف';
              studentId = (value['student_id'] is int)
                  ? value['student_id']
                  : int.tryParse(value['student_id'].toString());
            });
            return;
          }
        }
      } else if (data is Map) {
        for (var entry in data.entries) {
          final value = entry.value;
          final emailInDb = value['email']?.toString().trim();
          if (emailInDb == widget.studentEmail.trim()) {
            setState(() {
              studentName = "${value['first_name'] ?? ''} ${value['last_name'] ?? ''}".trim();
              studentClass = value['class_id'] ?? 'غير معروف';
              studentId = (value['student_id'] is int)
                  ? value['student_id']
                  : int.tryParse(value['student_id'].toString());
            });
            return;
          }
        }
      }
      setState(() {
        studentName = 'بيانات غير صحيحة';
        studentClass = 'غير معروف';
        studentId = null;
      });
    } else {
      setState(() {
        studentName = 'لا توجد بيانات';
        studentClass = 'غير معروف';
        studentId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مرحبا بك 👋'),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => Login()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            studentName == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مرحبًا، $studentName',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'الصف: ${studentClass ?? 'غير معروف'}',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
            const SizedBox(height: 20),
            const Text(
              'القائمة الرئيسية',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                children: [
                  _buildCard(context, Icons.book, 'الدروس'),
                  _buildCard(context, Icons.grade, 'العلامات'),
                  _buildCard(context, Icons.schedule, 'الجدول'),
                  _buildCard(context, Icons.check_circle, 'الحضور والغياب'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String label) {
    return Card(
      color: Colors.blueAccent[100],
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          if (label == 'العلامات') {
            if (studentClass != null && studentId != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GradesScreen(
                    classId: studentClass!,
                    studentId: studentId!,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('بيانات الطالب غير مكتملة')),
              );
            }
          } else if (label == 'الجدول') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ScheduleScreen()));
          } else if (label == 'الدروس') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => LessonsScreen()));
          } else if (label == 'الحضور والغياب') {
            if (studentClass != null && studentId != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AttendanceScreen(
                    classId: studentClass!,
                    studentId: studentId!,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('بيانات الطالب غير مكتملة')),
              );
            }
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
