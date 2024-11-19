import 'package:flutter/material.dart';

class AddMedicationReminderScreen extends StatefulWidget {
  const AddMedicationReminderScreen({super.key});

  @override
  State<AddMedicationReminderScreen> createState() =>
      _AddMedicationReminderScreenState();
}

class _AddMedicationReminderScreenState
    extends State<AddMedicationReminderScreen> {
  TextEditingController _medicationController = TextEditingController();
  TextEditingController _dosageController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // ฟังก์ชันสำหรับเลือกวันที่
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

  // ฟังก์ชันสำหรับเลือกเวลา
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มการเตือนทานยา'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // ชื่อยา
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
        
              // ขนาดยา
              const Text(
                'ขนาดยา (มิลลิกรัม):',
                style: TextStyle(fontSize: 18),
              ),
              TextField(
                controller: _dosageController,
                decoration: const InputDecoration(
                  hintText: 'กรอกขนาดยา',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
        
              // วันทานยา
              const Text(
                'วันทานยา:',
                style: TextStyle(fontSize: 18),
              ),
              TextField(
                controller: TextEditingController(text: '${_selectedDate.toLocal()}'.split(' ')[0]),
                decoration: const InputDecoration(
                  hintText: 'เลือกวันทานยา',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 20),
        
              // เวลา
              const Text(
                'เวลา:',
                style: TextStyle(fontSize: 18),
              ),
              TextField(
                controller: TextEditingController(text: _selectedTime.format(context)),
                decoration: const InputDecoration(
                  hintText: 'เลือกเวลา',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 20),
        
              // รายละเอียด
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
        
              // ปุ่มบันทึก
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // บันทึกข้อมูลการเตือนทานยา
                    print('ชื่อยา: ${_medicationController.text}');
                    print('ขนาดยา: ${_dosageController.text}');
                    print('วันทานยา: $_selectedDate');
                    print('เวลา: $_selectedTime');
                    print('รายละเอียด: ${_detailsController.text}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('บันทึก'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
