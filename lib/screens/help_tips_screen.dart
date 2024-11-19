import 'package:flutter/material.dart';

class HelpTipsScreen extends StatelessWidget {
  const HelpTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('คำแนะนำด้านสุขภาพ'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // ตัวอย่างบทความแรก
          Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: const Icon(Icons.health_and_safety, size: 50, color: Colors.blueAccent),
              title: const Text(
                'วิธีการดูแลสุขภาพผู้สูงอายุในฤดูร้อน',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'การดูแลผู้สูงอายุในช่วงฤดูร้อนควรมีการระวังเรื่องอากาศร้อนและการขาดน้ำ...',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                // เปิดบทความเต็ม
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const ArticleDetailScreen(),
                //   ),
                // );
              },
            ),
          ),
          // ตัวอย่างบทความที่สอง
          Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: const Icon(Icons.medical_services, size: 50, color: Colors.blueAccent),
              title: const Text(
                'การเลือกอาหารที่เหมาะสมสำหรับผู้สูงอายุ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'การเลือกอาหารที่ดีและเหมาะสมสำหรับผู้สูงอายุสามารถช่วยเสริมสร้างสุขภาพ...',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {

              },
            ),
          ),
          // เพิ่มบทความหรือคำแนะนำอื่นๆ ตามที่ต้องการ
        ],
      ),
    );
  }
}
