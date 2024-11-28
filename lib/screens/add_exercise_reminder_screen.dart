import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddExerciseReminderScreen extends StatefulWidget {
  const AddExerciseReminderScreen({super.key});

  @override
  State<AddExerciseReminderScreen> createState() =>
      _AddExerciseReminderScreenState();
}

class _AddExerciseReminderScreenState extends State<AddExerciseReminderScreen> {
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveReminder() async {
    if (_activityController.text.isEmpty || _detailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบ')),
      );
      return;
    }

    final newReminder = {
      'activity': _activityController.text,
      'details': _detailsController.text,
      'date': _selectedDate.toIso8601String(),
      'time': _selectedTime.format(context),
      'status': 'รอดําเนินการ',
    };

    final prefs = await SharedPreferences.getInstance();
    final reminders = prefs.getStringList('exerciseReminders') ?? [];
    reminders.add(jsonEncode(newReminder));
    await prefs.setStringList('exerciseReminders', reminders);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('บันทึกข้อมูลแจ้งเตือนออกกำลังกายสําเร็จ')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'เพิ่มการเตือนออกกำลังกาย',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'กิจกรรมออกกำลังกาย:',
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                controller: _activityController,
                decoration: const InputDecoration(
                  hintText: 'กรอกชื่อกิจกรรม',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'วันออกกำลังกาย:',
                style: TextStyle(fontSize: 18),
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: DateFormat('dd/MM/yyyy').format(_selectedDate),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'เวลา:',
                style: TextStyle(fontSize: 18),
              ),
              GestureDetector(
                onTap: () => _selectTime(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: _selectedTime.format(context),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'รายละเอียด:',
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(
                  hintText: 'กรอกรายละเอียด',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save, color: Colors.white),
                  onPressed: _saveReminder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  label: const Text(
                    'บันทึก',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
