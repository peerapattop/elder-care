import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HealthCenterScreen extends StatefulWidget {
  const HealthCenterScreen({super.key});

  @override
  State<HealthCenterScreen> createState() => _HealthCenterScreenState();
}

class _HealthCenterScreenState extends State<HealthCenterScreen> {
  List<dynamic> healthCenters = [];
  bool isLoading = true;
  String typeInThai = '';

  String getTypeInThai(String type) {
    switch (type) {
      case 'hospital':
        return 'โรงพยาบาล';
      case 'clinic':
        return 'คลินิก';
      case 'pharmacy':
        return 'ร้านขายยา';
      default:
        return 'ไม่ระบุ';
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      throw 'ไม่สามารถโทรออกได้';
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'ไม่สามารถเปิดแอพอีเมลได้';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHealthCenters();
  }

  Future<void> fetchHealthCenters() async {
    const apiUrl = 'https://iamnet.me/api/community/health_centers.json';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          healthCenters = data['health_centers'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load health centers');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Centers'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: healthCenters.length,
                itemBuilder: (context, index) {
                  final center = healthCenters[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            center['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.blue,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ประเภท: ${getTypeInThai(center['type'])}',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'คะแนน: ${center['rating']} ⭐',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          const Divider(),
                          Text(
                            center['address'],
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.phone, color: Colors.green),
                                onPressed: () {
                                  // ตรวจสอบและโทรหาหมายเลขโทรศัพท์จากข้อมูลใน center
                                  final phoneNumber = center['contact']['phone'];
                                  if (phoneNumber != null) {
                                    _makePhoneCall(phoneNumber);
                                  } else {
                                    // แจ้งเตือนถ้าไม่มีหมายเลขโทรศัพท์
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('หมายเลขโทรศัพท์ไม่พร้อมใช้งาน')),
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.email, color: Colors.orange),
                                onPressed: () {
                                  // ตรวจสอบและส่งอีเมลจากข้อมูลใน center
                                  final email = center['contact']['email'];
                                  if (email != null) {
                                    _sendEmail(email);
                                  } else {
                                    // แจ้งเตือนถ้าไม่มีอีเมล
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('อีเมลไม่พร้อมใช้งาน')),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
