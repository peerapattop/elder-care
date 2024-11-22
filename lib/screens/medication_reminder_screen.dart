import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicationRemindersScreen extends StatefulWidget {
  const MedicationRemindersScreen({super.key});

  @override
  State<MedicationRemindersScreen> createState() =>
      _MedicationRemindersScreenState();
}

class _MedicationRemindersScreenState extends State<MedicationRemindersScreen> {
  List<dynamic> _medicationReminders = [];

  @override
  void initState() {
    super.initState();
    _loadMedicationReminders();
  }

  // ฟังก์ชันสำหรับโหลดรายการการเตือนทานยาจาก SharedPreferences
  Future<void> _loadMedicationReminders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedReminders = prefs.getString('medicationReminders');
    if (savedReminders != null) {
      setState(() {
        _medicationReminders = jsonDecode(savedReminders);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _medicationReminders.isEmpty
          ? const Center(child: Text('ไม่มีการเตือนทานยา'))
          : ListView.builder(
        itemCount: _medicationReminders.length,
        itemBuilder: (context, index) {
          final reminder = _medicationReminders[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(reminder['medication']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ขนาดยา: ${reminder['dosage']} มิลลิกรัม'),
                  Text('วันทานยา: ${reminder['date']}'),
                  Text('เวลา: ${reminder['time']}'),
                  Text('รายละเอียด: ${reminder['details']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
