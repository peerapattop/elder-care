import 'package:flutter/material.dart';

class ExerciseRemindersScreen extends StatefulWidget {
  const ExerciseRemindersScreen({super.key});

  @override
  State<ExerciseRemindersScreen> createState() =>
      _ExerciseRemindersScreenState();
}

class _ExerciseRemindersScreenState extends State<ExerciseRemindersScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('แจ้งเตือนการออกกำลังกาย'));
  }
}
