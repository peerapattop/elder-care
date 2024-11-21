import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpTipsScreen extends StatelessWidget {
  const HelpTipsScreen({super.key});

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'ไม่สามารถเปิดลิงก์ได้: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'คำแนะนำด้านสุขภาพ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        toolbarHeight: 70,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          GestureDetector(
            onTap: () {
              _launchURL('https://www.thairath.co.th/money/sustainability/esg_strategy/2819431');
            },
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.network(
                            'https://static.thairath.co.th/media/dFQROr7oWzulq5Fa6rBifUyYIpr6oTX4YMi4zzaCUYVj788yfLZWlnJn985faWXbgXp.jpg')
                            .image,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'จับเทรนด์อาหารเพื่อสุขภาพ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'เป้าหมายการพัฒนาที่ยั่งยืนจะต้องพัฒนา 3 เสาหลักให้เกิดการสมดุลกัน คือ สังคม เศรษฐกิจ และสิ่งแวดล้อม แต่มีสิ่งที่มากกว่านั้น คือ การพัฒนาร่างกายและจิตใจของคนเรา เรื่องใกล้ตัวที่สุด คือ การเลือกอาหารการกินเพื่อสุขภาพ ที่กำลังเป็น “เมกะเทรนด์” ของโลกยุคนี้',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                          TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _launchURL('https://www.thairath.co.th/money/sustainability/esg_strategy/2819431');
            },
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.network(
                            'https://static.thairath.co.th/media/dFQROr7oWzulq5Fa4ML4rWzJMONd6tMOwhn1urYCXJ3XzhUpaVRlOJhRyziSoe4aG7f.webp')
                            .image,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '9 อาหารเพื่อสุขภาพ ใกล้ตัวจนหลายคนมองข้าม',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ภาพลักษณ์ของอาหารเพื่อสุขภาพที่หลายคนนึกถึง คืออาหารที่มีราคาแพงและหาซื้อได้ยาก วันนี้เราเลยคัดเลือกอาหารเพื่อสุขภาพที่หาซื้อง่าย อยู่ใกล้ตัว ชนิดที่ว่าเปิดตู้เย็นในบ้านตอนนี้ก็อาจจะเจอเลยก็ได้ ไปดูกันเลยว่ามีอะไรบ้าง',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                          TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
