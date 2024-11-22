import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController diseaseController;
  final TextEditingController relativeController;
  final TextEditingController relativePhoneController;
  final TextEditingController doctorController;
  final TextEditingController doctorPhoneController;
  final TextEditingController hospitalController;
  final TextEditingController hospitalPhoneController;

  const EditProfileScreen({
    Key? key,
    required this.nameController,
    required this.ageController,
    required this.diseaseController,
    required this.relativeController,
    required this.relativePhoneController,
    required this.doctorController,
    required this.doctorPhoneController,
    required this.hospitalController,
    required this.hospitalPhoneController,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'แก้ไขข้อมูลส่วนตัว',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        toolbarHeight: 70,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEditableCard(
                controller: widget.nameController,
                hint: 'ชื่อ',
              ),
              _buildEditableCard(
                controller: widget.ageController,
                hint: 'อายุ',
              ),
              _buildEditableCard(
                controller: widget.diseaseController,
                hint: 'โรคประจำตัว',
              ),
              _buildEditableCard(
                controller: widget.relativeController,
                hint: 'ข้อมูลญาติ',
              ),
              _buildEditableCard(
                controller: widget.relativePhoneController,
                hint: 'เบอร์โทรญาติ',
              ),
              _buildEditableCard(
                controller: widget.doctorController,
                hint: 'หมอ',
              ),
              _buildEditableCard(
                controller: widget.doctorPhoneController,
                hint: 'เบอร์โทรหมอ',
              ),
              _buildEditableCard(
                controller: widget.hospitalController,
                hint: 'โรงพยาบาล',
              ),
              _buildEditableCard(
                controller: widget.hospitalPhoneController,
                hint: 'เบอร์โทรโรงพยาบาล',
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save, color: Colors.white),
                  onPressed: () {
                    _saveData();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent),
                  label: const Text(
                    'บันทึก',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', widget.nameController.text);
    await prefs.setString('age', widget.ageController.text);
    await prefs.setString('disease', widget.diseaseController.text);
    await prefs.setString('relative', widget.relativeController.text);
    await prefs.setString('relativePhone', widget.relativePhoneController.text);
    await prefs.setString('doctor', widget.doctorController.text);
    await prefs.setString('doctorPhone', widget.doctorPhoneController.text);
    await prefs.setString('hospital', widget.hospitalController.text);
    await prefs.setString('hospitalPhone', widget.hospitalPhoneController.text);

    print('ข้อมูลถูกบันทึก');
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
}
