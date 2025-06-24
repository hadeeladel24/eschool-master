import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AttendanceScreen extends StatefulWidget {
  final String classId; // مثل "class-2"
  final int studentId;  // مثل 2

  const AttendanceScreen({
    super.key,
    required this.classId,
    required this.studentId,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final database = FirebaseDatabase.instance.ref();
  Map<String, String> attendanceRecords = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    final classAttendanceRef = database.child('attendance').child(widget.classId);
    final snapshot = await classAttendanceRef.get();

    print('📡 تحميل حضور الصف ${widget.classId} للطالب ${widget.studentId}');
    print('📦 البيانات الكاملة: ${snapshot.value}');

    if (snapshot.exists) {
      final data = snapshot.value;
      Map<String, String> records = {};

      if (data is Map) {
        data.forEach((date, attendanceData) {
          print('📅 التاريخ: $date => $attendanceData');

          if (attendanceData is Map) {
            // حالة حضور بشكل Map مثل: { "2": { "status": "present" } }
            attendanceData.forEach((key, value) {
              if (key.toString() == widget.studentId.toString()) {
                if (value is Map && value.containsKey('status')) {
                  records[date.toString()] = value['status'].toString();
                  print('✅ تم تسجيل حضور/غياب لهذا التاريخ: $date الحالة: ${value['status']}');
                }
              }
            });
          } else if (attendanceData is List) {
            // حالة حضور بشكل List مثل: [null, null, { "status": "absent" }]
            int idx = widget.studentId;
            print('🔍 البحث في قائمة عند index $idx');
            if (idx >= 0 && idx < attendanceData.length) {
              final entry = attendanceData[idx];
              print('🔎 البيانات عند index $idx: $entry');
              if (entry is Map && entry.containsKey('status')) {
                records[date.toString()] = entry['status'].toString();
                print('✅ تم تسجيل حضور/غياب لهذا التاريخ: $date الحالة: ${entry['status']}');
              }
            }
          }
        });
      }

      setState(() {
        attendanceRecords = records;
        loading = false;
      });
    } else {
      print('❌ لا توجد بيانات حضور لهذا الصف');
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الحضور والغياب'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : attendanceRecords.isEmpty
              ? const Center(child: Text('لا توجد بيانات حضور'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: attendanceRecords.entries.map((entry) {
                    final date = entry.key;
                    final status = entry.value;
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          status == 'present' ? Icons.check_circle : Icons.cancel,
                          color: status == 'present' ? Colors.green : Colors.red,
                        ),
                        title: Text('📅 التاريخ: $date'),
                        subtitle: Text('📌 الحالة: ${status == 'present' ? 'حاضر' : 'غائب'}'),
                      ),
                    );
                  }).toList(),
                ),
    );
  }
}
