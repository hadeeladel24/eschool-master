import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddClass extends StatefulWidget {
  const AddClass({super.key});

  @override
  State<AddClass> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClass> {
  final _formKey = GlobalKey<FormState>();
  final _classNameController = TextEditingController();
  final _teacherIdController = TextEditingController();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref().child('Classes');

  void _addClass() async {
    if (_formKey.currentState!.validate()) {
      final className = _classNameController.text.trim();
      final teacherId = int.tryParse(_teacherIdController.text.trim());

      if (teacherId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid teacher id')),
        );
        return;
      }

      try {
        await _databaseRef.child(className).set({
          'class_name': className,
          'teacher_id': teacherId,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Class added successfully')),
        );

        _formKey.currentState!.reset();
        _classNameController.clear();
        _teacherIdController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '➕ إضافة صف جديد',
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
                        controller: _classNameController,
                        decoration: InputDecoration(
                          labelText: 'اسم الصف',
                          prefixIcon: const Icon(Icons.class_),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? '⚠️ أدخل اسم الصف' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _teacherIdController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'معرّف المعلم',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? '⚠️ أدخل معرف المعلم' : null,
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _addClass,
                          icon: const Icon(Icons.save),
                          label: const Text(
                            'حفظ الصف',
                            style: TextStyle(fontSize: 20),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 10,
                            shadowColor: Colors.blueAccent,
                          ),
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
