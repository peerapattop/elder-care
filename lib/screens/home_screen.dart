import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('หน้าหลัก',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ชื่อผู้ใช้ หรือการทักทาย
            const Text(
              'สวัสดีคุณ John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // การแจ้งเตือนการทานยา
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ListTile(
                leading: const Icon(Icons.medication, color: Colors.blueAccent),
                title: const Text('ทานยา: 08:00 AM',
                    style: TextStyle(fontSize: 18)),
                subtitle: const Text('กรุณาทานยาเพื่อสุขภาพที่ดี'),
                trailing: const Icon(Icons.notifications, color: Colors.green),
              ),
            ),

            // การพบแพทย์
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.medical_services,
                    color: Colors.blueAccent),
                title: const Text('พบแพทย์: Dr. Jane Smith',
                    style: TextStyle(fontSize: 18)),
                subtitle: const Text('การนัดหมายถัดไป: 10:00 AM'),
                trailing:
                    const Icon(Icons.calendar_today, color: Colors.orange),
              ),
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading:
                    const Icon(Icons.fitness_center, color: Colors.blueAccent),
                title: const Text('ออกกำลังกาย: เดิน 30 นาที',
                    style: TextStyle(fontSize: 18)),
                subtitle: const Text('เพื่อสุขภาพที่ดีและแข็งแรง'),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
              ),
            ),

            const SizedBox(height: 30),

            // ปุ่มแจ้งเตือนเพิ่มเติม
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // เพิ่มฟังก์ชันการแจ้งเตือน
                  print('แจ้งเตือนข้อมูลเพิ่มเติม');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('ดูข้อมูลเพิ่มเติม'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
