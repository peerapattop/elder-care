import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = '';

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      throw 'ไม่สามารถโทรออกได้';
    }
  }

  String aqi = "80";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
    });
  }

  Future<Map<String, dynamic>?> _getNearestAppointment() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? appointmentsJson = prefs.getString('appointments');

    if (appointmentsJson == null) {
      return null; // หากไม่มีข้อมูลการนัดหมาย
    }

    final List<Map<String, dynamic>> appointments =
    List<Map<String, dynamic>>.from(json.decode(appointmentsJson));

    // แปลงวันที่และเวลาเป็น DateTime เพื่อคำนวณ
    final now = DateTime.now();

    appointments.sort((a, b) {
      final DateTime dateTimeA = DateTime.parse('${a['appointmentDate']} ${a['appointmentTime']}');
      final DateTime dateTimeB = DateTime.parse('${b['appointmentDate']} ${b['appointmentTime']}');
      return dateTimeA.compareTo(dateTimeB);
    });

    // กรองเฉพาะเวลาที่มากกว่าหรือเท่ากับเวลาปัจจุบัน
    final nearestAppointments = appointments.where((appointment) {
      final DateTime appointmentDateTime =
      DateTime.parse('${appointment['appointmentDate']} ${appointment['appointmentTime']}');
      return appointmentDateTime.isAfter(now);
    }).toList();

    return nearestAppointments.isNotEmpty ? nearestAppointments.first : null;
  }


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
            Text(
              'สวัสดีคุณ $name',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "$aqi µg/m³",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                leading: Icon(Icons.medication, color: Colors.blueAccent),
                title: Text('ทานยา: 08:00 AM', style: TextStyle(fontSize: 18)),
                subtitle: Text('กรุณาทานยาเพื่อสุขภาพที่ดี'),
                trailing: Icon(Icons.notifications, color: Colors.green),
              ),
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ListTile(
                leading: Icon(Icons.medical_services, color: Colors.blueAccent),
                title: Text('พบแพทย์: Dr. Jane Smith',
                    style: TextStyle(fontSize: 18)),
                subtitle: Text('การนัดหมายถัดไป: 10:00 AM'),
                trailing: Icon(Icons.calendar_today, color: Colors.orange),
              ),
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ListTile(
                leading: Icon(Icons.medical_services, color: Colors.blueAccent),
                title: Text('กิจกรรม: วิ่ง 30 นาที ',
                    style: TextStyle(fontSize: 18)),
                subtitle: Text('การนัดหมายถัดไป: 10:00 AM'),
                trailing: Icon(Icons.calendar_today, color: Colors.orange),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('ช่วยเหลือ'),
                contentPadding: const EdgeInsets.all(16.0),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // โทรติดต่อโรงพยาบาล
                        _makePhoneCall("0801234567");
                      },
                      icon:
                          const Icon(Icons.local_hospital, color: Colors.white),
                      label: const Text(
                        'ติดต่อโรงพยาบาล',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        // โทรติดต่อญาติ
                        _makePhoneCall("0897654321");
                      },
                      icon: const Icon(Icons.family_restroom,
                          color: Colors.white),
                      label: const Text(
                        'ติดต่อญาติ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      print('ตกลง');
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text(
                      'ตกลง',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.warning, color: Colors.white),
      ),
    );
  }
}
