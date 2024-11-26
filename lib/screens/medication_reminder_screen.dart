import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicationRemindersScreen extends StatefulWidget {
  const MedicationRemindersScreen({super.key});

  @override
  State<MedicationRemindersScreen> createState() =>
      _MedicationRemindersScreenState();
}

class _MedicationRemindersScreenState extends State<MedicationRemindersScreen> {
  List<Map<String, dynamic>> _medicationReminders = [];

  @override
  void initState() {
    super.initState();
    _loadMedicationReminders();
  }

  Future<void> _loadMedicationReminders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedReminders = prefs.getString('medicationReminders');
    print(savedReminders);

    if (savedReminders != null) {
      try {
        final List<dynamic> decodedReminders = jsonDecode(savedReminders);
        setState(() {
          _medicationReminders = decodedReminders
              .map((x) => Map<String, dynamic>.from(x as Map))
              .toList();
        });
      } catch (e) {
        // กรณีข้อมูลผิดพลาด
        print("Error decoding medication reminders: $e");
      }
    }
  }

  Future<void> _saveMedicationReminders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedReminders = jsonEncode(_medicationReminders);
    await prefs.setString('medicationReminders', encodedReminders);
  }

  void _markAsTaken(int index) {
    setState(() {
      final currentStatus = _medicationReminders[index]['status'];
      _medicationReminders[index]['status'] =
          currentStatus == 'รอดำเนินการ' ? 'เสร็จสิ้น' : 'รอดำเนินการ';
    });
    _saveMedicationReminders();
  }

  void _deleteReminder(int index) {
    setState(() {
      _medicationReminders.removeAt(index);
    });
    _saveMedicationReminders();
  }

  String formatDate(String date) {
    try {
      final DateFormat inputFormat = DateFormat('yyyy-MM-dd');
      final DateFormat outputFormat = DateFormat('dd/MM/yyyy');
      final DateTime dateTime = inputFormat.parse(date);
      return outputFormat.format(dateTime);
    } catch (e) {
      return "รูปแบบวันที่ไม่ถูกต้อง";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _medicationReminders.isEmpty
          ? const Center(
              child: Text(
                'ไม่มีการเตือนทานยา',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _medicationReminders.length,
              itemBuilder: (context, index) {
                final reminder = _medicationReminders[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.blue.shade300,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ยา: ${reminder['medication']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'ขนาดยา: ${reminder['dosage']} เม็ด',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'วันที่: ${formatDate(reminder['date'])}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            'เวลา: ${reminder['time']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'รายละเอียดยา: ${reminder['details']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _markAsTaken(index),
                                icon: Icon(
                                  reminder['status'] == 'เสร็จสิ้น'
                                      ? Icons
                                          .check_circle_outline // ไอคอนสำหรับ 'เสร็จสิ้น'
                                      : Icons
                                          .check_circle, // ไอคอนสำหรับ 'รอดำเนินการ'
                                  size: 20,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  reminder['status'] == 'เสร็จสิ้น'
                                      ? 'เสร็จสิ้น'
                                      : 'ยืนยันกินยา', // แสดงข้อความตามสถานะ
                                  style: const TextStyle(fontSize: 16),
                                ),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: reminder['status'] ==
                                          'เสร็จสิ้น'
                                      ? Colors.grey
                                          .shade500 // สีปุ่มสำหรับ 'เสร็จสิ้น'
                                      : Colors.green
                                          .shade700, // สีปุ่มสำหรับ 'รอดำเนินการ'
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () => _deleteReminder(index),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
