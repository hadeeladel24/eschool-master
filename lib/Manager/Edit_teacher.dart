import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditTeacher extends StatefulWidget {
  const EditTeacher({super.key});

  @override
  State<EditTeacher> createState() => _EditTeacherScreenState();
}

class _EditTeacherScreenState extends State<EditTeacher> {
  final _formKey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.ref();

  final _teacherIdController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _genderController = TextEditingController();
  final _specializationController = TextEditingController();
  final _salaryController = TextEditingController();

  bool _teacherinfo = false;

  Future<void> _loadTeacherData() async {
    final id = _teacherIdController.text;
    if (id.isEmpty) return;
    final snapshot = await _database.child('teachers/$id').get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      setState(() {
        _firstNameController.text = data['first_name'] ?? '';
        _lastNameController.text = data['last_name'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone_number'] ?? '';
        _addressController.text = data['address'] ?? '';
        _birthDateController.text = data['birth_date'] ?? '';
        _genderController.text = data['gender'] ?? '';
        _specializationController.text = data['specialization'] ?? '';
        _salaryController.text = data['salary']?.toString() ?? '';
        _teacherinfo = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The teacher is not found')),
      );
      setState(() {
        _teacherinfo = false;
      });
    }
  }

  Future<void> _updateTeacherData() async {
    final id = _teacherIdController.text;
    if (_formKey.currentState!.validate()) {
      await _database.child('teachers/$id').update({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'email': _emailController.text,
        'phone_number': _phoneController.text,
        'address': _addressController.text,
        'birth_date': _birthDateController.text,
        'gender': _genderController.text,
        'specialization': _specializationController.text,
        'salary': _salaryController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The Teacher Information Updated Successfully')),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: Colors.blue) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.95),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Enter $label' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Teacher Information'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFBBDEFB), Color(0xFF90CAF9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTextField(
                controller: _teacherIdController,
                label: 'Teacher ID',
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadTeacherData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text('Load Teacher Information'),
              ),
              const SizedBox(height: 16),
              if (_teacherinfo)
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
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          icon: Icons.phone,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _addressController,
                          label: 'Address',
                          icon: Icons.home,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _birthDateController,
                          label: 'Birth Date',
                          icon: Icons.calendar_today,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _genderController,
                          label: 'Gender',
                          icon: Icons.person_2,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _specializationController,
                          label: 'Specialization',
                          icon: Icons.school,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _salaryController,
                          label: 'Salary',
                          icon: Icons.money,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _updateTeacherData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Update',
                            style: TextStyle(fontWeight: FontWeight.bold),
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
