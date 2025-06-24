import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditStudent extends StatefulWidget {
  const EditStudent({super.key});

  @override
  State<EditStudent> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudent> {
  final _formKey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.ref();

  final _studentIdController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _genderController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _classIdController = TextEditingController();
  final _statusController = TextEditingController();
  final _enrollmentDateController = TextEditingController();

  bool _studentInfoLoaded = false;

  Future<void> _loadStudentData() async {
    final id = _studentIdController.text;
    if (id.isEmpty) return;

    final snapshot = await _database.child('Students/$id').get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      setState(() {
        _firstNameController.text = data['first_name'] ?? '';
        _lastNameController.text = data['last_name'] ?? '';
        _phoneController.text = data['phone_number'] ?? '';
        _genderController.text = data['gender'] ?? '';
        _birthDateController.text = data['BOD'] ?? '';
        _classIdController.text = data['class_id'] ?? '';
        _statusController.text = data['status'] ?? '';
        _enrollmentDateController.text = data['enrollment_date'] ?? '';
        _studentInfoLoaded = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student not found')),
      );
      setState(() {
        _studentInfoLoaded = false;
      });
    }
  }

  Future<void> _updateStudentData() async {
    final id = _studentIdController.text;
    if (_formKey.currentState!.validate()) {
      await _database.child('Students/$id').update({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'phone_number': _phoneController.text,
        'gender': _genderController.text,
        'BOD': _birthDateController.text,
        'class_id': _classIdController.text,
        'status': _statusController.text,
        'enrollment_date': _enrollmentDateController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student information updated successfully')),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.95),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter $label';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Student Information'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB3E5FC), // Light Blue
              Color(0xFF81D4FA), // Sky Blue
              Color(0xFF4FC3F7), // Medium Blue
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTextField(
                controller: _studentIdController,
                label: 'Student ID',
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadStudentData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Load Student Information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              if (_studentInfoLoaded)
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        _buildTextField(
                          controller: _firstNameController,
                          label: 'First Name',
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _lastNameController,
                          label: 'Last Name',
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          icon: Icons.phone,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _genderController,
                          label: 'Gender',
                          icon: Icons.wc,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _birthDateController,
                          label: 'Birth Date',
                          icon: Icons.calendar_today,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _classIdController,
                          label: 'Class ID',
                          icon: Icons.class_,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _statusController,
                          label: 'Status',
                          icon: Icons.info,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _enrollmentDateController,
                          label: 'Enrollment Date',
                          icon: Icons.date_range,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _updateStudentData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade800,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Update',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
