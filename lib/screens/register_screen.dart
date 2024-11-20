import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลงทะเบียนผู้สูงอายุ'),
        backgroundColor: Colors.blueAccent, // เปลี่ยนสีของ AppBar
      ),
      backgroundColor: Colors.white, // พื้นหลังเป็นสีขาว
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // การจัดเรียงแบบ Row (ช่องกรอกข้อมูล 2 ช่องใน 1 แถว)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ช่องกรอกชื่อ
                  Expanded(
                    child: _buildTextField(controller: nameController, label: 'ชื่อ', keyboardType: TextInputType.text, icon: Icons.person),
                  ),
                  const SizedBox(width: 16), // ระยะห่างระหว่างช่องกรอก
                  // ช่องกรอกอายุ
                  Expanded(
                    child: _buildTextField(controller: ageController, label: 'อายุ', keyboardType: TextInputType.number, icon: Icons.calendar_today),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ช่องกรอกโรคประจำตัวในแถวเดียว
              _buildTextField(controller: diseaseController, label: 'โรคประจำตัว', keyboardType: TextInputType.text, icon: Icons.medical_services),
              const SizedBox(height: 16),

              // การจัดเรียงแบบ Row สำหรับช่องกรอกข้อมูลญาติและเบอร์โทรศัพท์ญาติ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ช่องกรอกข้อมูลญาติ
                  Expanded(
                    child: _buildTextField(controller: relativeController, label: 'ชื่อญาติ', keyboardType: TextInputType.text, icon: Icons.family_restroom),
                  ),
                  const SizedBox(width: 16), // ระยะห่างระหว่างช่องกรอก
                  // ช่องกรอกเบอร์โทรศัพท์ญาติ
                  Expanded(
                    child: _buildTextField(controller: relativePhoneController, label: 'เบอร์โทรศัพท์ญาติ', keyboardType: TextInputType.phone, icon: Icons.phone),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // การจัดเรียงแบบ Row สำหรับช่องกรอกข้อมูลหมอและเบอร์โทรศัพท์หมอ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ช่องกรอกข้อมูลหมอ
                  Expanded(
                    child: _buildTextField(controller: doctorController, label: 'ชื่อหมอ', keyboardType: TextInputType.text, icon: Icons.person_outline),
                  ),
                  const SizedBox(width: 16), // ระยะห่างระหว่างช่องกรอก
                  // ช่องกรอกเบอร์โทรศัพท์หมอ
                  Expanded(
                    child: _buildTextField(controller: doctorPhoneController, label: 'เบอร์โทรศัพท์หมอ', keyboardType: TextInputType.phone, icon: Icons.phone_in_talk),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ช่องกรอกโรงพยาบาล
              _buildTextField(controller: hospitalController, label: 'โรงพยาบาล', keyboardType: TextInputType.text, icon: Icons.local_hospital),
              const SizedBox(height: 16),

              // ช่องกรอกเบอร์โทรศัพท์โรงพยาบาล
              _buildTextField(controller: hospitalPhoneController, label: 'เบอร์โทรศัพท์โรงพยาบาล', keyboardType: TextInputType.phone, icon: Icons.phone),
              const SizedBox(height: 30),

              // ปุ่มลงทะเบียน
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // ถ้าผู้ใช้กรอกข้อมูลครบถ้วน สามารถทำการลงทะเบียนได้
                      print('ลงทะเบียนสำเร็จ');
                    }
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // เพิ่มระยะห่างระหว่างฟิลด์
      child: SizedBox(
        width: double.infinity, // ให้ TextField ขยายเต็มความกว้าง
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.black), // เปลี่ยนข้อความให้เป็นสีดำ
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: Colors.black, // ป้ายให้เป็นสีดำ
            ),
            hintText: 'กรุณากรอกข้อมูล',
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Icon(icon, color: Colors.blueAccent), // ไอคอนเป็นสีฟ้า
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
