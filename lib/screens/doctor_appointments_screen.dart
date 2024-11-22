import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  State<DoctorAppointmentsScreen> createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen> {
  List<Map<String, String>> appointments = [];

  Future<void> _loadAppointments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final appointmentsString = prefs.getString('appointments') ?? '[]';

    final List<dynamic> appointmentsList = json.decode(appointmentsString);

    setState(() {
      appointments = (appointmentsList).map((appointment) {
        final Map<String, dynamic> dynamicMap = appointment as Map<String, dynamic>;
        return dynamicMap.map((key, value) => MapEntry(key, value.toString()));
      }).toList();
    });

  }


  Widget _buildAppointmentDetail(String label, String detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              detail,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appointments.isEmpty
          ? const Center(
        child: Text(
          'ไม่มีข้อมูลหมอนัด',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Card(
            margin: const EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.2),
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: const Icon(
                  Icons.medical_services,
                  color: Colors.blueAccent,
                ),
                title: Text(
                  'หมอ ${appointment['doctorName']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAppointmentDetail(
                          'สถานที่', appointment['location'] ?? 'ไม่มีข้อมูล'),
                      _buildAppointmentDetail(
                          'รายละเอียด', appointment['details'] ?? 'ไม่มีข้อมูล'),
                      _buildAppointmentDetail(
                          'วันที่', appointment['appointmentDate'] ?? 'ไม่มีข้อมูล'),
                      _buildAppointmentDetail(
                          'เวลา', appointment['appointmentTime'] ?? 'ไม่มีข้อมูล'),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}