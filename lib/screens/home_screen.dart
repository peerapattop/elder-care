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
  Map<String, dynamic>? nextExercise;
  Map<String, dynamic>? nextDoctorAppointment;

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      throw 'ไม่สามารถโทรออกได้';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadNextMedication();
    _loadNextDoctorAppointment();
    _loadNextExercise();
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

  Future<void> _loadNextDoctorAppointment() async {
    final doctorAppointment = await getNextDoctorAppointment();
    setState(() {
      nextDoctorAppointment = doctorAppointment;
    });
  }

  Future<void> _loadNextExercise() async {
    final exercise = await getNextExercise();
    setState(() {
      nextExercise = exercise;
    });
  }

  Future<Map<String, dynamic>?> getNextDoctorAppointment() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // ดึงข้อมูลจาก SharedPreferences
      String? storedData = prefs.getString('appointments');

      if (storedData == null) {
        print("No appointments found");
        return null;
      }

      String decodedData = storedData.replaceAll('&quot;', '"');

      List<dynamic> appointmentsList = jsonDecode(decodedData);

      List<Map<String, dynamic>> doctors = appointmentsList.map((item) {
        return Map<String, dynamic>.from(item);
      }).toList();

      if (doctors.isEmpty) {
        print("No upcoming doctor appointments found.");
        return null;
      }

      final DateTime now = DateTime.now();
      final dateTimeFormat = DateFormat("yyyy-MM-dd hh:mm a");

      // Filter upcoming appointments where status is NOT 'เสร็จสิ้น'
      final List<Map<String, dynamic>> upcomingDoctorsAppointments = doctors.where((doctor) {
        try {
          final String dateString = doctor['appointmentDate'] ?? '';
          final String timeString = doctor['appointmentTime'] ?? '';

          final DateTime doctorDateTime = dateTimeFormat.parse('$dateString $timeString');

          final bool isConfirmed = doctor['isConfirmed'] ?? false;
          final String status = doctor['status']?.toLowerCase() ?? '';

          // ตรวจสอบสถานะ และแสดงข้อมูลที่ยังไม่เสร็จสิ้น
          return doctorDateTime.isAfter(now) && !isConfirmed && status != 'หาหมอแล้ว';
        } catch (e) {
          print("Error parsing doctor appointment: $e");
          return false;
        }
      }).toList();

      if (upcomingDoctorsAppointments.isEmpty) {
        print("No upcoming doctor appointments found.");
        return null;
      }

      // จัดเรียงตามวันเวลา
      upcomingDoctorsAppointments.sort((a, b) {
        final DateTime dateTimeA = dateTimeFormat.parse('${a['appointmentDate']} ${a['appointmentTime']}');
        final DateTime dateTimeB = dateTimeFormat.parse('${b['appointmentDate']} ${b['appointmentTime']}');
        return dateTimeA.compareTo(dateTimeB);
      });

      final closestDoctor = upcomingDoctorsAppointments.first;
      print("Closest upcoming appointment: $closestDoctor");

      return closestDoctor;

    } catch (e) {
      print("Unexpected error in getNextDoctorAppointment: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getNextExercise() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final List<String>? exercisesJsonList = prefs.getStringList('exerciseReminders');
      print('exercisesJsonList from SharedPreferences: $exercisesJsonList');

      if (exercisesJsonList == null || exercisesJsonList.isEmpty) {
        return null;
      }

      final List<Map<String, dynamic>> exercises = exercisesJsonList
          .map((item) => Map<String, dynamic>.from(jsonDecode(item)))
          .toList();

      print('exercises: $exercises');

      final DateTime now = DateTime.now();
      final dateFormat = DateFormat("yyyy-MM-dd");
      final timeFormat = DateFormat("hh:mm a");

      final upcomingExercises = exercises.where((exercise) {
        try {
          final String dateString = exercise['date'];
          final String timeString = exercise['time'];

          final DateTime exerciseDate = dateFormat.parse(dateString.split('T')[0]);
          final DateTime exerciseTime = timeFormat.parse(timeString);

          final DateTime exerciseDateTime = DateTime(
            exerciseDate.year,
            exerciseDate.month,
            exerciseDate.day,
            exerciseTime.hour,
            exerciseTime.minute,
          );

          final bool isConfirmed = exercise['isConfirmed'] ?? false;
          final String status = exercise['status'] ?? '';

          return exerciseDateTime.isAfter(now) &&
              !isConfirmed &&
              status != 'เสร็จสิ้น';
        } catch (e) {
          print("Error parsing date or time: $e");
          return false;
        }
      }).toList();

      if (upcomingExercises.isEmpty) {
        print("No upcoming exercise found.");
        return null;
      }
      upcomingExercises.sort((a, b) {
        final DateTime timeA = dateFormat.parse(a['date']);
        final DateTime timeB = dateFormat.parse(b['date']);
        return timeA.compareTo(timeB);
      });

      final closestExercise = upcomingExercises.first;
      print("Closest upcoming exercise: $closestExercise");
      return closestExercise;
    } catch (e) {
      print("Unexpected error in getNextExercise: $e");
      return null;
    }
  }

  String formatDate(String date) {
    final DateFormat inputFormat = DateFormat('yyyy-MM-dd');
    final DateFormat outputFormat = DateFormat('dd/MM/yyyy');
    final DateTime dateTime = inputFormat.parse(date);
    return outputFormat.format(dateTime);
  }

  Future<Map<String, dynamic>?> getNextMedicationTime() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? medicationsJson = prefs.getString('medicationReminders');
      print('medicationsJson from shared preferences: $medicationsJson');

      if (medicationsJson == null || medicationsJson.isEmpty) {
        return null;
      }

      final List<dynamic> decodedJson = json.decode(medicationsJson);
      final List<Map<String, dynamic>> medications =
          decodedJson.map((item) => Map<String, dynamic>.from(item)).toList();
      print('medications: $medications');

      if (medications.isEmpty) {
        return null;
      }

      final DateTime now = DateTime.now();
      final dateFormat = DateFormat("yyyy-MM-dd hh:mm a");

      final upcomingMedications = medications.where((medication) {
        try {
          final DateTime medicationTime =
              dateFormat.parse('${medication['date']} ${medication['time']}');
          print('Checking medication time: $medicationTime, Now: $now');

          final bool isConfirmed = medication['isConfirmed'] ?? false;
          return medicationTime.isAfter(now) &&
              !isConfirmed &&
              medication['status'] != 'เสร็จสิ้น';
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
                        'วันที่: ${formatDate(nextMedication?['date'])} เวลา: ${nextMedication?['time']}',
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
                  trailing: const Icon(Icons.warning, color: Colors.red),
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
            if(nextDoctorAppointment != null)...[
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const Icon(Icons.medical_services, color: Colors.blueAccent),
                  title: Text(
                    'พบแพทย์: ${nextDoctorAppointment?['doctorName']}',
                    style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'วันที่: ${formatDate(nextDoctorAppointment?['appointmentDate'])}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'เวลา: ${nextDoctorAppointment?['appointmentTime']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'สถานที่: ${nextDoctorAppointment?['location']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'รายละเอียด: ${nextDoctorAppointment?['details']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.calendar_today, color: Colors.orange),
                ),
              ),

            ]else ...[
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const ListTile(
                  leading:
                  Icon(Icons.medical_services, color: Colors.blueAccent),
                  title: Text(
                    'ไม่มีแจ้งเตือนพบหมอ',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],

            if (nextExercise != null) ...[
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const Icon(Icons.medical_services,
                      color: Colors.blueAccent),
                  title: Text(
                      'กิจกรรม: ${nextExercise?['activity'] ?? 'ไม่ระบุ'}',
                      style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold )),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'วันที่: ${formatDate(nextExercise?['date'])} เวลา ${nextExercise?['time']}'),
                      Text('รายละเอียด ${nextExercise!['details']}',style: const TextStyle(fontSize: 14))
                    ],
                  ),
                  trailing: const Icon(Icons.warning, color: Colors.red),
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
                  leading:
                      Icon(Icons.medical_services, color: Colors.blueAccent),
                  title: Text(
                    'ไม่มีแจ้งเตือนออกกำลังกาย',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ]
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
