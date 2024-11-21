import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_screen.dart'; // นำเข้า EditProfileScreen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    _loadData();
  }

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
              _buildProfileSection(),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // ไปยังหน้าจอ EditProfileScreen เมื่อกดปุ่ม
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfileScreen(
                        nameController: nameController,
                        ageController: ageController,
                        diseaseController: diseaseController,
                        relativeController: relativeController,
                        relativePhoneController: relativePhoneController,
                        doctorController: doctorController,
                        doctorPhoneController: doctorPhoneController,
                        hospitalController: hospitalController,
                        hospitalPhoneController: hospitalPhoneController,
                      )),

                    );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text(
                    'แก้ไขโปรไฟล์',
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

  Widget _buildProfileSection() {
    return Column(
      children: [
        _buildProfileCard(
          icon: Icons.person,
          title: nameController.text,
          subtitle: 'ชื่อ',
        ),
        _buildProfileCard(
          icon: Icons.calendar_today,
          title: ageController.text,
          subtitle: 'อายุ',
        ),
        _buildProfileCard(
          icon: Icons.healing,
          title: diseaseController.text,
          subtitle: 'โรคประจําตัว',
        ),
        _buildProfileCard(
          icon: Icons.family_restroom,
          title: relativeController.text,
          subtitle: 'ข้อมูลญาติ',
          trailing: _buildPhoneRow(relativePhoneController.text),
        ),
        _buildProfileCard(
          icon: Icons.medical_services,
          title: doctorController.text,
          subtitle: 'หมอ',
          trailing: _buildPhoneRow(doctorPhoneController.text),
        ),
        _buildProfileCard(
          icon: Icons.local_hospital,
          title: hospitalController.text,
          subtitle: 'โรงพยาบาล',
          trailing: _buildPhoneRow(hospitalPhoneController.text),
        ),
      ],
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
