import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddTeacher extends StatefulWidget {
  const AddTeacher({super.key});

  @override
  State<AddTeacher> createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference _dataref = FirebaseDatabase.instance.ref().child('teachers');

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _createdAtController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _gender;

  Future<int> _getTeacherId() async {
    final snapshot = await _dataref.get();
    if (!snapshot.exists) return 0;

    final keys = snapshot.children
        .map((child) => int.tryParse(child.key ?? '') ?? 0)
        .where((id) => id != 0)
        .toList();

    if (keys.isEmpty) return 0;

    keys.sort();
    return keys.last;
  }

  void _addTeacher() async {
    if (_formKey.currentState!.validate()) {
      try {
        final lastId = await _getTeacherId();
        final newId = lastId + 1;
        await _dataref.child(newId.toString()).set({
          'teacher_id': newId,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'birth_date': _birthDateController.text,
          'created_at': _createdAtController.text,
          'email': _emailController.text,
          'phone_number': _phoneNumberController.text,
          'salary': _salaryController.text,
          'specialization': _specializationController.text,
          'address': _addressController.text,
          'gender': _gender,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Teacher added successfully')),
        );

        _formKey.currentState!.reset();
        setState(() {
          _gender = null;
          _firstNameController.clear();
          _lastNameController.clear();
          _addressController.clear();
          _birthDateController.clear();
          _createdAtController.clear();
          _emailController.clear();
          _phoneNumberController.clear();
          _salaryController.clear();
          _specializationController.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add teacher')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Teacher'),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: Container(
        color: Colors.blue[50], // خلفية هادية وبسيطة جداً
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_firstNameController, 'First Name'),
                const SizedBox(height: 16),
                _buildTextField(_lastNameController, 'Last Name'),
                const SizedBox(height: 16),
                _buildTextField(_birthDateController, 'Birth Date'),
                const SizedBox(height: 16),
                _buildTextField(_createdAtController, 'Created At'),
                const SizedBox(height: 16),
                _buildTextField(_emailController, 'Email', type: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildTextField(_phoneNumberController, 'Phone Number', type: TextInputType.phone),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Select Gender' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(_salaryController, 'Salary', type: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField(_specializationController, 'Specialization'),
                const SizedBox(height: 16),
                _buildTextField(_addressController, 'Address'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addTeacher,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Add Teacher',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType type = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Enter $label' : null,
    );
  }
}
