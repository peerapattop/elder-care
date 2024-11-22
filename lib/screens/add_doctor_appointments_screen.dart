import 'dart:convert'; // สำหรับการจัดการ JSON
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // สำหรับการจัดการวันที่
import 'package:shared_preferences/shared_preferences.dart'; // สำหรับ SharedPreferences

class AddDoctorAppointmentsScreen extends StatefulWidget {
  const AddDoctorAppointmentsScreen({super.key});

  @override
  State<AddDoctorAppointmentsScreen> createState() =>
      _AddDoctorAppointmentsScreenState();
}

class _AddDoctorAppointmentsScreenState
    extends State<AddDoctorAppointmentsScreen> {
  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _saveAppointment() async {
    if (_doctorNameController.text.isEmpty || _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบ')),
      );
      return;
    }

    final newAppointment = {
      'doctorName': _doctorNameController.text,
      'location': _locationController.text,
      'details': _detailsController.text,
      'appointmentDate': DateFormat('yyyy-MM-dd').format(_selectedDate),
      'appointmentTime': _selectedTime.format(context),
    };

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? appointmentsJson = prefs.getString('appointments');
    List<Map<String, dynamic>> appointments = [];

    if (appointmentsJson != null) {
      // ถ้ามีข้อมูลนัดหมายเดิมให้นำมาถอดรหัส JSON
      appointments = List<Map<String, dynamic>>.from(json.decode(appointmentsJson));
    }

    // เพิ่มนัดหมายใหม่เข้าไปในรายการ
    appointments.add(newAppointment);

    // เข้ารหัสรายการทั้งหมดเป็น JSON และบันทึกใน SharedPreferences
    await prefs.setString('appointments', json.encode(appointments));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('บันทึกข้อมูลการนัดหมายสำเร็จ')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'เพิ่มหมอนัด',
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
                'ชื่อหมอ:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _doctorNameController,
                decoration: const InputDecoration(
                  hintText: 'กรอกชื่อหมอ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'วันที่นัดหมาย:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                'สถานที่นัดหมาย:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  hintText: 'กรอกสถานที่นัดหมาย',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'รายละเอียดการนัดหมาย:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _detailsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'กรอกรายละเอียดเพิ่มเติม',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save, color: Colors.white),
                  onPressed: _saveAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  label: const Text(
                    'บันทึก',
                    style: TextStyle(color: Colors.white),
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
