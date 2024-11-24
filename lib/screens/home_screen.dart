import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = '';
  Map<String, dynamic>? nextMedication;

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
    _loadNextMedication();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
    });
  }

  Future<void> _loadNextMedication() async {
    final medication = await getNextMedicationTime();
    setState(() {
      nextMedication = medication;
    });
  }

  Future<Map<String, dynamic>?> getNextMedicationTime() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? medicationsJson = prefs.getString('medicationReminders');
      print('medicationsJson from shared preferences: $medicationsJson');

      if (medicationsJson == null || medicationsJson.isEmpty) {
        print("No medication reminders found in shared preferences.");
        return null;
      }

      final List<dynamic> decodedJson = json.decode(medicationsJson);
      final List<Map<String, dynamic>> medications =
          decodedJson.map((item) => Map<String, dynamic>.from(item)).toList();
      print('medications: $medications');

      if (medications.isEmpty) {
        print("Medication list is empty.");
        return null;
      }

      final DateTime now = DateTime.now();
      final dateFormat = DateFormat("yyyy-MM-dd hh:mm a");

      medications.sort((a, b) {
        try {
          final DateTime medicationTimeA =
              dateFormat.parse('${a['date']} ${a['time']}');
          final DateTime medicationTimeB =
              dateFormat.parse('${b['date']} ${b['time']}');
          return medicationTimeA.compareTo(medicationTimeB);
        } catch (e) {
          print("Error parsing date or time during sort: $e");
          return 0;
        }
      });

      final upcomingMedications = medications.where((medication) {
        try {
          final dateFormat = DateFormat("yyyy-MM-dd hh:mm a");
          final DateTime medicationTime =
              dateFormat.parse('${medication['date']} ${medication['time']}');
          return medicationTime.isAfter(now);
        } catch (e) {
          print("Error parsing date or time: $e");
          return false;
        }
      }).toList();

      if (upcomingMedications.isEmpty) {
        print("No upcoming medication found.");
        return null;
      }

      upcomingMedications.sort((a, b) {
        final dateFormat = DateFormat("yyyy-MM-dd hh:mm a");
        final DateTime timeA = dateFormat.parse('${a['date']} ${a['time']}');
        final DateTime timeB = dateFormat.parse('${b['date']} ${b['time']}');
        return timeA.compareTo(timeB);
      });

      final closestMedication = upcomingMedications.first;
      print("Closest upcoming medication: $closestMedication");
      return closestMedication;
    } catch (e) {
      print("Unexpected error in getNextMedicationTime: $e");
      return null;
    }
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
            if (nextMedication != null) ...[
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading:
                      const Icon(Icons.medication, color: Colors.blueAccent),
                  title: Text(
                    'ทานยา: ${nextMedication?['medication'] ?? 'ไม่ระบุ'}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'จำนวนยา: ${nextMedication?['dosage'] ?? 0} เม็ด',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'เวลา: ${nextMedication?['time'] ?? 'ไม่ระบุ'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (nextMedication?['details']?.isNotEmpty == true)
                        Text(
                          'รายละเอียด: ${nextMedication?['details']}',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                    ],
                  ),
                  trailing: const Icon(Icons.check_box, color: Colors.green),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ] else ...[
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const ListTile(
                  leading: Icon(Icons.medication, color: Colors.blueAccent),
                  title: Text(
                    'ไม่มีแจ้งเตือนทานยา',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
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
