import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DeleteTeacher extends StatefulWidget {
  const DeleteTeacher({Key? key}) : super(key: key);

  @override
  State<DeleteTeacher> createState() => _DeleteTeacherPageState();
}

class _DeleteTeacherPageState extends State<DeleteTeacher> {
  final _teacherIdController = TextEditingController();
  final _databaseRef = FirebaseDatabase.instance.ref().child('teachers');

  Future<void> _deleteTeacher() async {
    final teacherIdText = _teacherIdController.text.trim();
    if (teacherIdText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Teacher Id')),
      );
      return;
    }

    try {
      final teacherRef = _databaseRef.child(teacherIdText);

      final snapshot = await teacherRef.get();
      if (!snapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Teacher not Found')),
        );
      } else {
        await teacherRef.remove();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Teacher Deleted Successfully')),
        );
        _teacherIdController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _teacherIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('delete teacher information'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 8,
        shadowColor: Colors.blueAccent.shade100,
      ),
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
        padding:  EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 14,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _teacherIdController,
                      decoration: InputDecoration(
                        labelText: 'please enter teacher id',
                        prefixIcon: const Icon(Icons.person_search, color: Colors.blue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),

                      ),
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
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTK2W3noOx1p78322OqOGghLVbGhLE2nmChUg&s',
                              width: 280,
                              height: 280,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _deleteTeacher,
                              icon: const Icon(Icons.delete_forever, size: 28,color:Colors.white),
                              label: const Text(
                                'delete teacher',
                                style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold),
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
