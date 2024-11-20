import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;

  // TextEditingController สำหรับฟิลด์ข้อมูลที่ต้องการแก้ไข
  final TextEditingController nameController = TextEditingController(text: 'John Doe');
  final TextEditingController ageController = TextEditingController(text: '70');
  final TextEditingController diseaseController = TextEditingController(text: 'Hypertension, Diabetes');
  final TextEditingController relativeController = TextEditingController(text: 'นายจำนง ทรงศรี');
  final TextEditingController doctorController = TextEditingController(text: 'Dr. Jane Smith');
  final TextEditingController hospitalController = TextEditingController(text: 'โรงพยาบาลพญาไท');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'ข้อมูลส่วนตัว',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // แสดงข้อมูลหรือ TextField ขึ้นอยู่กับว่าเป็นโหมดแก้ไขหรือไม่
              isEditing ? _buildEditableCard(
                controller: nameController,
                hint: 'ชื่อ',
              ) : _buildProfileCard(
                icon: Icons.person,
                title: nameController.text,
                subtitle: 'ชื่อ',
              ),
              isEditing ? _buildEditableCard(
                controller: ageController,
                hint: 'อายุ',
              ) : _buildProfileCard(
                icon: Icons.calendar_today,
                title: ageController.text,
                subtitle: 'อายุ',
              ),
              isEditing ? _buildEditableCard(
                controller: diseaseController,
                hint: 'โรคประจําตัว',
              ) : _buildProfileCard(
                icon: Icons.healing,
                title: diseaseController.text,
                subtitle: 'โรคประจําตัว',
              ),
              isEditing ? _buildEditableCard(
                controller: relativeController,
                hint: 'ข้อมูลญาติ',
              ) : _buildProfileCard(
                icon: Icons.medical_services,
                title: relativeController.text,
                subtitle: 'ข้อมูลญาติ',
                trailing: _buildPhoneRow('089-123-4567'),
              ),
              isEditing ? _buildEditableCard(
                controller: doctorController,
                hint: 'หมอ',
              ) : _buildProfileCard(
                icon: Icons.medical_services,
                title: doctorController.text,
                subtitle: 'หมอ',
                trailing: _buildPhoneRow('089-123-4567'),
              ),
              isEditing ? _buildEditableCard(
                controller: hospitalController,
                hint: 'โรงพยาบาล',
              ) : _buildProfileCard(
                icon: Icons.medical_services,
                title: hospitalController.text,
                subtitle: 'โรงพยาบาล',
                trailing: _buildPhoneRow('089-123-4567'),
              ),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                    if (!isEditing) {
                      // บันทึกข้อมูลเมื่อออกจากโหมดแก้ไข (อาจเพิ่มการบันทึกข้อมูลที่นี่)
                      print('ข้อมูลถูกบันทึก');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text(
                    isEditing ? 'บันทึกโปรไฟล์' : 'แก้ไขโปรไฟล์',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableCard({
    required TextEditingController controller,
    required String hint,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        subtitle: Text(subtitle),
        trailing: trailing,
      ),
    );
  }

  Widget _buildPhoneRow(String phoneNumber) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.phone, color: Colors.blueAccent),
        const SizedBox(width: 5),
        Text(
          phoneNumber,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
