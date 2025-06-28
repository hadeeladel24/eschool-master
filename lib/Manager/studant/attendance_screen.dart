import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AttendanceScreen extends StatefulWidget {
  final String classId;
  final int studentId;

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

    print(' attendance class is loading ${widget.classId} for student ${widget.studentId}');
    print('Complete information ${snapshot.value}');

    if (snapshot.exists) {
      final data = snapshot.value;
      Map<String, String> records = {};

      if (data is Map) {
        data.forEach((date, attendanceData) {
          print(' date: $date => $attendanceData');

          if (attendanceData is Map) {
            attendanceData.forEach((key, value) {
              if (key.toString() == widget.studentId.toString()) {
                if (value is Map && value.containsKey('status')) {
                  records[date.toString()] = value['status'].toString();
                  print(' Attendance/absence recorded for this date: $date state: ${value['status']}');
                }
              }
            });
          } else if (attendanceData is List) {
            int idx = widget.studentId;
            print('search in list index $idx');
            if (idx >= 0 && idx < attendanceData.length) {
              final entry = attendanceData[idx];
              print(' information in index $idx: $entry');
              if (entry is Map && entry.containsKey('status')) {
                records[date.toString()] = entry['status'].toString();
                print(' Attendance/absence recorded for this date: $date state: ${entry['status']}');
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
      print(' No data attendance found fo this class');
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('presence and absence'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : attendanceRecords.isEmpty
          ? const Center(child: Text('No attendance data found'))
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
              title: Text(' date: $date'),
              subtitle: Text(' state: ${status == 'present' ? 'present' : 'absent'}'),
            ),
          );
        }).toList(),
      ),
    );
  }
}