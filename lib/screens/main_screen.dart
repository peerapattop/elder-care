import 'package:flutter/material.dart';

import '../widgets/my_bottom_navigation_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const MyBottomNavigationBar(),
    );
  }
}
