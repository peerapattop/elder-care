import 'package:elder_care/screens/add_medication_reminder_screen.dart';
import 'package:flutter/material.dart';
import 'add_doctor_appointments_screen.dart';
import 'add_exercise_reminder_screen.dart';
import 'doctor_appointments_screen.dart';
import 'exercise_reminder_screen.dart';
import 'medication_reminder_screen.dart'; // หน้ารายการหมอนัด
// import 'medication_reminders_screen.dart'; // หน้ารายการกินยา
// import 'exercise_reminders_screen.dart'; // หน้ารายการออกกำลังกาย

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการกิจกรรมสุขภาพ'),
        backgroundColor: Colors.blueAccent,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'หมอนัด'),
            Tab(text: 'กินยา'),
            Tab(text: 'ออกกำลังกาย'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DoctorAppointmentsScreen(), // หน้ารายการหมอนัด
          MedicationRemindersScreen(), // หน้ารายการกินยา
          ExerciseRemindersScreen(), // หน้ารายการออกกำลังกาย
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // เมื่อกดปุ่ม + จะเปิด Bottom Sheet ให้เลือกการเพิ่ม
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.schedule),
                      title: const Text('เพิ่มการนัดหมายหมอ'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const AddDoctorAppointmentsScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.medication),
                      title: const Text('เพิ่มยาที่ต้องการแจ้งเตือน'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                            const AddMedicationReminderScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.fitness_center),
                      title: const Text('เพิ่มกิจกรรมออกกำลังกาย'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const AddExerciseReminderScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
