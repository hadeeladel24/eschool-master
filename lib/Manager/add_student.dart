import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference _databaseref =
      FirebaseDatabase.instance.ref().child('Students');

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _enrollmentDateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  String? chooseGender;
  String? chooseClassId;

  final List<String> classIds = [
    'class-1', 'class-2', 'class-3', 'class-4', 'class-5',
    'class-6', 'class-7', 'class-8', 'class-9', 'class-10', 'class-11'
  ];

  Future<int> _getStudentId() async {
    final snapshot = await _databaseref.get();
    if (!snapshot.exists) return 0;

    final keys = snapshot.children
        .map((child) => int.tryParse(child.key ?? '') ?? 0)
        .where((key) => key != 0)
        .toList();

    if (keys.isEmpty) return 0;

    keys.sort();
    return keys.last;
  }

  void _addStudent() async {
    if (_formKey.currentState!.validate()) {
      try {
        int lastId = await _getStudentId();
        int newId = lastId + 1;

        await _databaseref.child(newId.toString()).set({
          'student_id': newId,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'email':_emailController.text,
          'BOD': _birthdateController.text,
          'enrollment_date': _enrollmentDateController.text,
          'gender': chooseGender,
          'phone_number': _phoneNumberController.text,
          'status': _statusController.text,
          'class_id': chooseClassId,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student added successfully')),
        );

        _formKey.currentState!.reset();
        setState(() {
          chooseGender = null;
          chooseClassId = null;
          _firstNameController.clear();
          _lastNameController.clear();
          _emailController.clear();
          _birthdateController.clear();
          _enrollmentDateController.clear();
          _phoneNumberController.clear();
          _statusController.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add student')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Container(
        decoration: const BoxDecoration(

            color:Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTextField(_firstNameController, 'First Name'),
                   SizedBox(height: 16),
                  _buildTextField(_lastNameController, 'Last Name'),
                   SizedBox(height: 16),
                  _buildTextField(_emailController, 'Email'),
                   SizedBox(height: 16),
                  _buildTextField(_birthdateController, 'Birth Date'),
                   SizedBox(height: 16),
                  _buildTextField(_enrollmentDateController, 'Enrollment Date'),
                   SizedBox(height: 16),
                  _buildDropdownField(
                    label: 'Gender',
                    value: chooseGender,
                    items: ['Male', 'Female'],
                    onChanged: (value) => setState(() => chooseGender = value),
                  ),
                   SizedBox(height: 16),
                  _buildTextField(_phoneNumberController, 'Phone Number'),
                   SizedBox(height: 16),
                  _buildTextField(_statusController, 'Status'),
                   SizedBox(height: 16),
                  _buildDropdownField(
                    label: 'Class ID',
                    value: chooseClassId,
                    items: classIds,
                    onChanged: (value) => setState(() => chooseClassId = value),
                  ),
                   SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _addStudent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding:  EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 40,
                      ),
                    ),
                    child:  Text(
                      'Add Student',
                      style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Enter $label' : null,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Choose $label' : null,
    );
  }
}
