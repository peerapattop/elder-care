import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMedicationReminderScreen extends StatefulWidget {
  const AddMedicationReminderScreen({super.key});

  @override
  State<AddMedicationReminderScreen> createState() =>
      _AddMedicationReminderScreenState();
}

class _AddMedicationReminderScreenState
    extends State<AddMedicationReminderScreen> {
  final TextEditingController _medicationController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
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

  Future<void> _saveMedicationReminder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final medicationReminder = {
      'medication': _medicationController.text,
      'dosage': _dosageController.text,
      'details': _detailsController.text,
      'date': "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}",
      'time': _selectedTime.format(context),
    };

    final String? savedReminders = prefs.getString('medicationReminders');
    List<dynamic> remindersList = savedReminders != null
        ? jsonDecode(savedReminders)
        : [];

    remindersList.add(medicationReminder);

    await prefs.setString('medicationReminders', jsonEncode(remindersList));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('บันทึกการเตือนสำเร็จ')),
    );

    _medicationController.clear();
    _dosageController.clear();
    _detailsController.clear();
    setState(() {
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'เพิ่มการเตือนทานยา',
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
                'ชื่อยา:',
                style: TextStyle(fontSize: 18),
              ),
              TextField(
                controller: _medicationController,
                decoration: const InputDecoration(
                  hintText: 'กรอกชื่อยา',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'ขนาดยา (เม็ด):',
                style: TextStyle(fontSize: 18),
              ),
              TextField(
                controller: _dosageController,
                decoration: const InputDecoration(
                  hintText: 'กรอกจำนวน',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              const Text(
                'วันทานยา:',
                style: TextStyle(fontSize: 18),
              ),
              TextField(
                controller: TextEditingController(
                  text:
                  "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                ),
                decoration: const InputDecoration(
                  hintText: 'เลือกวันที่',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 20),
              const Text(
                'เวลา:',
                style: TextStyle(fontSize: 18),
              ),
              TextField(
                controller:
                TextEditingController(text: _selectedTime.format(context)),
                decoration: const InputDecoration(
                  hintText: 'เลือกเวลา',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 20),
              const Text(
                'รายละเอียดยา:',
                style: TextStyle(fontSize: 18),
              ),
              TextField(
                controller: _detailsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'กรอกรายละเอียดยา',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save, color: Colors.white),
                  onPressed: () async {
                    if (_medicationController.text.isEmpty ||
                        _dosageController.text.isEmpty ||
                        _detailsController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบ')),
                      );
                      return;
                    }
                    await _saveMedicationReminder();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
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