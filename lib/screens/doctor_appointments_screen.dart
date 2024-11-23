import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Future<void> _saveAppointments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(appointments);
    await prefs.setString('appointments', encodedData);
  }

  void _deleteAppointment(int index) async {
    setState(() {
      appointments.removeAt(index);
    });
    await _saveAppointments();
  }

  void _markAppointmentAsDone(int index) async {
    setState(() {
      appointments[index]['status'] = 'หาหมอแล้ว';
    });
    await _saveAppointments();
  }

  String formatDate(String date) {
    final DateFormat inputFormat = DateFormat('yyyy-MM-dd');
    final DateFormat outputFormat = DateFormat('dd/MM/yyyy');
    final DateTime dateTime = inputFormat.parse(date);
    return outputFormat.format(dateTime);
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
          final isDone = appointment['status'] == 'หาหมอแล้ว';
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.2),
            color: Colors.white,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
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
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAppointmentDetail('สถานที่', appointment['location'] ?? 'ไม่มีข้อมูล'),
                          _buildAppointmentDetail('รายละเอียด', appointment['details'] ?? 'ไม่มีข้อมูล'),
                          _buildAppointmentDetail('วันที่', formatDate(appointment['appointmentDate']!)),
                          _buildAppointmentDetail('เวลา', appointment['appointmentTime'] ?? 'ไม่มีข้อมูล'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  _markAppointmentAsDone(index);
                                },
                                icon: Icon(
                                  isDone ? Icons.check_circle_outline : Icons.check_circle,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  isDone ? 'หาหมอแล้ว' : 'ยืนยันพบหมอ',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: isDone
                                      ? Colors.grey.shade500
                                      : Colors.green.shade700,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _deleteAppointment(index);
                    },
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
