import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ExerciseRemindersScreen extends StatefulWidget {
  const ExerciseRemindersScreen({super.key});

  @override
  State<ExerciseRemindersScreen> createState() =>
      _ExerciseRemindersScreenState();
}

class _ExerciseRemindersScreenState extends State<ExerciseRemindersScreen> {
  List<Map<String, dynamic>> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final reminders = prefs.getStringList('exerciseReminders') ?? [];
    setState(() {
      _reminders = reminders
          .map((reminder) => jsonDecode(reminder) as Map<String, dynamic>)
          .toList();
    });
  }

  void _markAsCompleted(int index) {
    setState(() {
      _reminders[index]['status'] = 'เสร็จสิ้น';
    });
    _saveReminders();
  }

  void _deleteReminder(int index) {
    setState(() {
      _reminders.removeAt(index);
    });
    _saveReminders();
  }

  Future<void> _saveReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final reminders = _reminders.map((reminder) => jsonEncode(reminder)).toList();
    await prefs.setStringList('exerciseReminders', reminders);
  }

  String formatDate(String date) {
    final DateFormat inputFormat = DateFormat('yyyy-MM-dd');
    final DateFormat outputFormat = DateFormat('dd/MM/yyyy');
    final DateTime dateTime = inputFormat.parse(date);
    return outputFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _reminders.isEmpty
          ? const Center(
        child: Text(
          'ยังไม่มีการแจ้งเตือนออกกำลังกาย',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: _reminders.length,
        itemBuilder: (context, index) {
          final reminder = _reminders[index];
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
                      'กิจกรรม: ${reminder['activity']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'วันที่: ${formatDate(reminder['date'])}',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      'เวลา: ${reminder['time']}',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'รายละเอียด: ${reminder['details']}',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            _markAsCompleted(index);
                          },
                          icon: Icon(
                            reminder['status'] == 'เสร็จสิ้น'
                                ? Icons.check_circle_outline
                                : Icons.check_circle,
                            size: 20,
                            color: Colors.white,
                          ),
                          label: Text(
                            reminder['status'] == 'เสร็จสิ้น'
                                ? 'ทำเสร็จแล้ว'
                                : 'ยืนยันกิจกรรม',
                            style: const TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                            reminder['status'] == 'เสร็จสิ้น'
                                ? Colors.grey.shade500
                                : Colors.green.shade700,
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