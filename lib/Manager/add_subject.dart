import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({super.key});

  @override
  State<AddSubject> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubject> {
  final _formKey = GlobalKey<FormState>();
  final _subjectIdController = TextEditingController();
  final _subjectNameController = TextEditingController();
  final DatabaseReference _databaseRef =
  FirebaseDatabase.instance.ref().child('Subjects');

  bool _isValidFirebaseKey(String key) {
    return key.isNotEmpty && !key.contains(RegExp(r'[.#$/\[\]]'));
  }

  void _addSubject() async {
    final subjectId = _subjectIdController.text.trim();
    final subjectName = _subjectNameController.text.trim();

    if (!_isValidFirebaseKey(subjectId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invaled Entered')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      try {
        print('🟡 adding subject is in process: $subjectId → $subjectName');

        await _databaseRef.child(subjectId).set({
          'subject_name': subjectName,
        });

        print('✅ adding subject succsessfully in  Firebase');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ adding subject succsessfully')),
        );

        _formKey.currentState!.reset();
        _subjectIdController.clear();
        _subjectNameController.clear();
      } catch (e) {
        print('❌ Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Invaled adding: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade400,
              Colors.blue.shade200,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "➕ اضافة مادة جديدة",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.blue.shade300,
                              offset: const Offset(2, 2),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _subjectIdController,
                        decoration: InputDecoration(
                          labelText: "رمز المادة",
                          prefixIcon: const Icon(Icons.code),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? " ادخل رمز المادة"
                            : null,
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: _subjectNameController,
                        decoration: InputDecoration(
                          labelText: "اسم المادة الكامل ",
                          prefixIcon: const Icon(Icons.book),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? "ادخل اسم المادة الكامل  "
                            : null,
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: _addSubject,
                        icon: const Icon(Icons.save),
                        label: const Text(
                          "Add Subject",
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 10,
                          shadowColor: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}