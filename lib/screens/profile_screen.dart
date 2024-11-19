import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                'https://randomuser.me/api/portraits/women/64.jpg',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ListTile(
                leading:  Icon(Icons.person, color: Colors.blueAccent),
                title:  Text('John Doe', style: TextStyle(fontSize: 18)),
                subtitle:  Text('ชื่อ'),
              )
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ListTile(
                leading:  Icon(Icons.calendar_today, color: Colors.blueAccent),
                title:  Text('70', style: TextStyle(fontSize: 18)),
                subtitle:  Text('อายุ'),
              ),
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ListTile(
                leading:  Icon(Icons.healing, color: Colors.blueAccent),
                title:  Text('Hypertension, Diabetes', style: TextStyle(fontSize: 18)),
                subtitle:  Text('โรคประจําตัว'),
              ),
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ListTile(
                leading:  Icon(Icons.medical_services, color: Colors.blueAccent),
                title:  Text('Dr. Jane Smith', style: TextStyle(fontSize: 18)),
                subtitle: Text('หมอ'),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // ลิงก์ไปยังหน้าที่ใช้แก้ไขข้อมูลโปรไฟล์
                  // คุณสามารถใช้ Navigator.push() ไปยังหน้าที่ต้องการได้
                  print('Go to Edit Profile');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('แก้ไขโปรไฟล์', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
