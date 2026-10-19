import 'package:flutter/material.dart';
import 'package:mobile_app/core/navigation/app_router.dart';
import 'package:mobile_app/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppRouter.navigatorKey,
      title: 'MULTIAZ',
      theme: AppTheme.darkTheme,
      initialRoute: '/home',
      routes: AppRouter.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

