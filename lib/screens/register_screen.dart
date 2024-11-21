import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers สำหรับเก็บค่าที่ผู้ใช้กรอก
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController diseaseController = TextEditingController();
  final TextEditingController relativeController = TextEditingController();
  final TextEditingController relativePhoneController = TextEditingController();
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController doctorPhoneController = TextEditingController();
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController hospitalPhoneController = TextEditingController();

  // ฟังก์ชันที่ทำการบันทึกข้อมูลลงใน SharedPreferences
  Future<void> _saveRegistrationData() async {
    final prefs = await SharedPreferences.getInstance();

    // บันทึกข้อมูลลงใน SharedPreferences
    await prefs.setString('name', nameController.text);
    await prefs.setString('age', ageController.text);
    await prefs.setString('disease', diseaseController.text);
    await prefs.setString('relative', relativeController.text);
    await prefs.setString('relativePhone', relativePhoneController.text);
    await prefs.setString('doctor', doctorController.text);
    await prefs.setString('doctorPhone', doctorPhoneController.text);
    await prefs.setString('hospital', hospitalController.text);
    await prefs.setString('hospitalPhone', hospitalPhoneController.text);

    // ตั้งค่า isRegisterCompleted เป็น true
    await prefs.setBool('isRegisterCompleted', true);
  }

  // ฟังก์ชันที่ตรวจสอบและบันทึกข้อมูล
  Future<void> _completeRegistration(BuildContext context) async {
    // ตรวจสอบการกรอกข้อมูล
    if (_formKey.currentState?.validate() ?? false) {
      // ถ้าฟอร์มกรอกข้อมูลครบถ้วน
      await _saveRegistrationData(); // บันทึกข้อมูล

      print('ลงทะเบียนสำเร็จ');

      // ไปยังหน้าถัดไป
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลงทะเบียนผู้สูงอายุ'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ฟิลด์สำหรับกรอกข้อมูล (เหมือนเดิม)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildTextField(controller: nameController, label: 'ชื่อ', keyboardType: TextInputType.text, icon: Icons.person),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(controller: ageController, label: 'อายุ', keyboardType: TextInputType.number, icon: Icons.calendar_today),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(controller: diseaseController, label: 'โรคประจำตัว', keyboardType: TextInputType.text, icon: Icons.medical_services),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildTextField(controller: relativeController, label: 'ชื่อญาติ', keyboardType: TextInputType.text, icon: Icons.family_restroom),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(controller: relativePhoneController, label: 'เบอร์โทรศัพท์ญาติ', keyboardType: TextInputType.phone, icon: Icons.phone),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildTextField(controller: doctorController, label: 'ชื่อหมอ', keyboardType: TextInputType.text, icon: Icons.person_outline),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(controller: doctorPhoneController, label: 'เบอร์โทรศัพท์หมอ', keyboardType: TextInputType.phone, icon: Icons.phone_in_talk),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildTextField(controller: hospitalController, label: 'โรงพยาบาล', keyboardType: TextInputType.text, icon: Icons.local_hospital),
              const SizedBox(height: 16),

              _buildTextField(controller: hospitalPhoneController, label: 'เบอร์โทรศัพท์โรงพยาบาล', keyboardType: TextInputType.phone, icon: Icons.phone),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _completeRegistration(context); // เรียกฟังก์ชันตรวจสอบและบันทึกข้อมูล
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text(
                    'ลงทะเบียน',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันที่ใช้สร้าง TextFormField
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.black),
            hintText: 'กรุณากรอกข้อมูล',
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Icon(icon, color: Colors.blueAccent),
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณากรอกข้อมูล $label';
            }
            return null;
          },
        ),
      ),
    );
  }
}
