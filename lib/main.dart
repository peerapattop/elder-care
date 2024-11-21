import 'package:elder_care/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/welcome_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool isWelcomeCompleted = prefs.getBool('isWelcomeCompleted') ?? false;
  final bool isRegisterCompleted = prefs.getBool('isRegisterCompleted') ?? false;

  runApp(MyApp(
    isWelcomeCompleted: isWelcomeCompleted,
    isRegisterCompleted: isRegisterCompleted,
  ));
}

class MyApp extends StatelessWidget {
  final bool isWelcomeCompleted;
  final bool isRegisterCompleted;

  const MyApp({
    Key? key,
    required this.isWelcomeCompleted,
    required this.isRegisterCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: _getInitialScreen(),
    );
  }

  Widget _getInitialScreen() {
    if (!isWelcomeCompleted) {
      return const WelcomeScreen();
    } else if (!isRegisterCompleted) {
      return const RegisterScreen();
    } else {
      return const MainScreen();
    }
  }
}
