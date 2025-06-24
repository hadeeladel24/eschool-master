import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DeleteStudent extends StatefulWidget {
  const DeleteStudent({Key? key}) : super(key: key);

  @override
  State<DeleteStudent> createState() => _DeleteStudentPageState();
}

class _DeleteStudentPageState extends State<DeleteStudent> {
  final _studentIdController = TextEditingController();
  final _databaseRef = FirebaseDatabase.instance.ref().child('Students');

  Future<void> _deleteStudent() async {
    final studentIdText = _studentIdController.text.trim();
    if (studentIdText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Student Id')),
      );
      return;
    }

    try {
      final studentRef = _databaseRef.child(studentIdText);

      final snapshot = await studentRef.get();
      if (!snapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student not Found')),
        );
      } else {
        await studentRef.remove();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student Deleted Successfully')),
        );
        _studentIdController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar مع لون أزرق حي
      appBar: AppBar(
        title: const Text('حذف معلومات الطالب'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 8,
        shadowColor: Colors.blueAccent.shade100,
      ),
      // خلفية متدرجة أزرق هادي مع تباعد جيد
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade400,
              Colors.blue.shade200,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 14,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              color: Colors.white.withOpacity(0.95),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _studentIdController,
                      decoration: InputDecoration(
                        labelText: 'أدخل رقم الطالب',
                        prefixIcon: const Icon(Icons.person_search, color: Colors.blue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.blue.shade50,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade300, width: 2),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade100.withOpacity(0.5),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbc1KHxjYq5sraANm31Fe6JIpdmGFkR25zkA&s',
                              width: 280,
                              height: 280,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _deleteStudent,
                              icon: const Icon(Icons.delete_forever, size: 28),
                              label: const Text(
                                'حذف الطالب',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 12,
                                shadowColor: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
