import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/screens/auth/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MULTIAZ',
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => RegisterScreen(),
        '/home': (context) => Scaffold(body: Center(child: Text('HOME'))),
      },
    );
  }
}

