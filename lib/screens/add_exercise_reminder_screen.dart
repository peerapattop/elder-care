import 'package:flutter/material.dart';

class AddExerciseReminderScreen extends StatefulWidget {
  const AddExerciseReminderScreen({super.key});

  @override
  State<AddExerciseReminderScreen> createState() => _AddExerciseReminderScreenState();
}

class _AddExerciseReminderScreenState extends State<AddExerciseReminderScreen> {
  TextEditingController _activityController = TextEditingController();
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
        title: const Text('เพิ่มการเตือนออกกำลังกาย'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // กิจกรรมออกกำลังกาย
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกชื่อกิจกรรม';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // วัน
            const Text(
              'วันออกกำลังกาย:',
              style: TextStyle(fontSize: 18),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: TextEditingController(text: '${_selectedDate.toLocal()}'.split(' ')[0]),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'เลือกวันที่',
                  filled: true,
                  fillColor: Colors.white,
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
            ),
            const SizedBox(height: 20),

            // เวลา
            const Text(
              'เวลา:',
              style: TextStyle(fontSize: 18),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: TextEditingController(text: _selectedTime.format(context)),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'เลือกเวลา',
                  filled: true,
                  fillColor: Colors.white,
                ),
                readOnly: true,
                onTap: () => _selectTime(context),
              ),
            ),
            const SizedBox(height: 20),

            // รายละเอียด
            const Text(
              'รายละเอียด:',
              style: TextStyle(fontSize: 18),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: _detailsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'กรอกรายละเอียดกิจกรรม',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ปุ่มบันทึก
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // บันทึกข้อมูลการเตือนออกกำลังกาย
                  print('กิจกรรม: ${_activityController.text}');
                  print('วันที่: $_selectedDate');
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
    );
  }
}
