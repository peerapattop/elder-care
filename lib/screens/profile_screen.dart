import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;

  // TextEditingControllers for editable fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController diseaseController = TextEditingController();
  final TextEditingController relativeController = TextEditingController();
  final TextEditingController relativePhoneController = TextEditingController();
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController doctorPhoneController = TextEditingController();
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController hospitalPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData(); // Load data from SharedPreferences when the widget starts
  }

  // Function to load data from SharedPreferences
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('name') ?? '';
      ageController.text = prefs.getString('age') ?? '';
      diseaseController.text = prefs.getString('disease') ?? '';
      relativeController.text = prefs.getString('relative') ?? '';
      relativePhoneController.text = prefs.getString('relativePhone') ?? '';
      doctorController.text = prefs.getString('doctor') ?? '';
      doctorPhoneController.text = prefs.getString('doctorPhone') ?? '';
      hospitalController.text = prefs.getString('hospital') ?? '';
      hospitalPhoneController.text = prefs.getString('hospitalPhone') ?? '';
    });
  }

  // Function to save data to SharedPreferences
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('age', ageController.text);
    await prefs.setString('disease', diseaseController.text);
    await prefs.setString('relative', relativeController.text);
    await prefs.setString('relativePhone', relativePhoneController.text);
    await prefs.setString('doctor', doctorController.text);
    await prefs.setString('doctorPhone', doctorPhoneController.text);
    await prefs.setString('hospital', hospitalController.text);
    await prefs.setString('hospitalPhone', hospitalPhoneController.text);
  }

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
              // Display editable or profile card based on isEditing status
              _buildProfileSection(),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                    if (!isEditing) {
                      // Save data when leaving edit mode
                      _saveData();
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

  Widget _buildProfileSection() {
    return Column(
      children: [
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
          icon: Icons.family_restroom,
          title: relativeController.text,
          subtitle: 'ข้อมูลญาติ',
          trailing: _buildPhoneRow(relativePhoneController.text),
        ),
        isEditing ? _buildEditableCard(
          controller: doctorController,
          hint: 'หมอ',
        ) : _buildProfileCard(
          icon: Icons.medical_services,
          title: doctorController.text,
          subtitle: 'หมอ',
          trailing: _buildPhoneRow(doctorPhoneController.text),
        ),
        isEditing ? _buildEditableCard(
          controller: hospitalController,
          hint: 'โรงพยาบาล',
        ) : _buildProfileCard(
          icon: Icons.local_hospital,
          title: hospitalController.text,
          subtitle: 'โรงพยาบาล',
          trailing: _buildPhoneRow(hospitalPhoneController.text),
        ),
      ],
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
        keyboardType: TextInputType.text,
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
