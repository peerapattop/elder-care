import 'package:elder_care/screens/add_medication_reminder_screen.dart';
import 'package:flutter/material.dart';
import 'add_doctor_appointments_screen.dart';
import 'add_exercise_reminder_screen.dart';
import 'doctor_appointments_screen.dart';
import 'exercise_reminder_screen.dart';
import 'medication_reminder_screen.dart';

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
        centerTitle: true,
        title: const Text('จัดการกิจกรรมสุขภาพ',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        toolbarHeight: 70,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'หมอนัด'),
            Tab(text: 'กินยา'),
            Tab(text: 'ออกกำลังกาย'),
          ],
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.blueAccent,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DoctorAppointmentsScreen(),
          MedicationRemindersScreen(),
          ExerciseRemindersScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
